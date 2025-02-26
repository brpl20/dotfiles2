#!/bin/bash

# Linux Post-Installation Script
# This script installs common development tools and applications

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo "Please run this script as a normal user, not as root."
  exit 1
fi

# Check Linux distribution
DISTRO=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
CODENAME=$(grep -oP '(?<=^VERSION_CODENAME=).+' /etc/os-release | tr -d '"')

echo "Detected Linux distribution: $DISTRO ($CODENAME)"
if [ "$CODENAME" != "bookworm" ]; then
  read -p "This script was designed for Debian Bookworm. You're using $CODENAME. Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please edit the script to match your distribution and try again."
    exit 1
  fi
fi

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install basic applications
echo "Installing basic applications..."
sudo apt install -y curl git imagemagick jq unzip vim zsh tree

# Install Terminator
echo "Installing Terminator..."
sudo apt install -y terminator

# Install Atuin (shell history tool)
echo "Installing Atuin..."
bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  # Keep the current shell for now
  chsh -s $(which zsh) # Uncomment this line to change shell to zsh
else
  echo "Oh My Zsh is already installed"
fi

# Install Zsh syntax highlighting
echo "Installing Zsh syntax highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install GitHub CLI and login
echo "Installing GitHub CLI..."
sudo apt install -y gh
echo "Please authenticate with GitHub..."
gh auth login

# Install Google Chrome
echo "Installing Google Chrome..."
if ! command -v google-chrome &> /dev/null; then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
else
  echo "Google Chrome is already installed"
fi

# Install Insync
echo "Installing Insync..."
INSYNC_VERSION="3.9.4.60020"
INSYNC_URL="https://cdn.insynchq.com/builds/linux/${INSYNC_VERSION}/insync_${INSYNC_VERSION}-bookworm_amd64.deb"

# Check for newer versions
LATEST_INSYNC=$(curl -s https://www.insynchq.com/downloads | grep -oP 'insync_\K[0-9.]+(?=-bookworm_amd64.deb)' | head -1)
if [ ! -z "$LATEST_INSYNC" ] && [ "$LATEST_INSYNC" != "$INSYNC_VERSION" ]; then
  echo "Found newer Insync version: $LATEST_INSYNC"
  INSYNC_VERSION=$LATEST_INSYNC
  INSYNC_URL="https://cdn.insynchq.com/builds/linux/${INSYNC_VERSION}/insync_${INSYNC_VERSION}-bookworm_amd64.deb"
fi

wget "$INSYNC_URL"
sudo apt install -y "./insync_${INSYNC_VERSION}-bookworm_amd64.deb"
rm "./insync_${INSYNC_VERSION}-bookworm_amd64.deb"

# Install VS Code
echo "Installing Visual Studio Code..."
if ! command -v code &> /dev/null; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update
  sudo apt install -y code
else
  echo "VS Code is already installed"
fi

# Install Qalc extension for VS Code
echo "Installing Qalc extension for VS Code..."
code --install-extension svipas.control-panel

# Install Python and pip
echo "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Install Ruby, RVM and gems
echo "Installing Ruby, RVM and important gems..."
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
gem install bundler pry rails

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g yarn

# Install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Install Docker
echo "Installing Docker..."
sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER

# Create code directory and clone repositories
echo "Creating code directory and cloning repositories..."
mkdir -p ~/code
cd ~/code
gh repo clone brpl20/linux-install

# TODO tasks (to be implemented later)
echo "TODO tasks:"
echo "- Fix keyboard settings"
echo "- Fix terminator configs"
echo "- Install aliases"
echo "- Install Rust"

echo "Installation complete! Some changes may require a system restart to take effect."
echo "You may need to log out and log back in to use Docker without sudo."
