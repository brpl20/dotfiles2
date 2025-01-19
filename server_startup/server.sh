#!/bin/bash

# Update package list and upgrade all packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y curl gnupg2 build-essential libssl-dev libreadline-dev zlib1g-dev

# Install Node.js (required for Rails asset pipeline)
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Yarn (optional but recommended for managing JavaScript dependencies)
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update -y
sudo apt-get install -y yarn

# Install RVM (Ruby Version Manager)
curl -sSL https://get.rvm.io | bash -s stable

# Load RVM into shell session
source ~/.rvm/scripts/rvm

# Install the latest stable Ruby version
rvm install ruby --default

# Install Rails
gem install rails

# Install Zsh
sudo apt-get install -y zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Change default shell to Zsh
chsh -s $(which zsh)

# Verify installations
ruby -v
rails -v
node -v
yarn -v
zsh --version

echo "Setup complete. Ruby on Rails environment with Zsh is ready!"