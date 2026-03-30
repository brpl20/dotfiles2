# Guia de Reinstalacao - Debian 12 (Bookworm) + GNOME

## DADOS
~/nc/                      # Nextcloud
~/nc-dev/                  # NextCloud Dev
~/odd/                     # OneDrive Insync
~/DOWNLOADS/               # Downloads grandes
SyncThing                  # SyncThing -> /downloads e /DOWNLOADS


## Teclado 
Configurar teclado US-INT com ç e ~


## Repositorios APT Terceiros
- Docker CE & Desktop
- Google Chrome - ver perfis do Debian Bruno
- VS Code
- PostgreSQL (PGDG)
- Tailscale (pelli.br@)
- Syncthing
- Insync (One Drive Escritório)
- Git
- GH -> Logar 

## Pacotes APT

```bash
# Build essentials e compilacao
sudo apt install -y build-essential autoconf automake libtool pkg-config \
  gcc g++ clang make cmake git curl wget

# Shell e terminal
sudo apt install -y zsh tmux foot tree jq ghostty

# Ferramentas CLI modernas
sudo apt install -y fzf ripgrep fd-find eza zoxide

# Editores
sudo apt install -y vim

# Banco de dados
sudo apt install -y postgresql-18 postgresql-client-18 libpq-dev

# Web server
sudo apt install -y nginx

# Rede e cloud
sudo apt install -y tailscale syncthing openssh-server

# GPU NVIDIA -> Ver se é necessário

# Screenshot e midia
sudo apt install -y flameshot vlc obs-studio audacity

# Produtividade
sudo apt install -y libreoffice 

# Documentos e conversao
sudo apt install -y pandoc imagemagick ffmpeg

# Python dev
sudo apt install -y python3 python3-pip python3-venv python3-dev

# Ruby dev (dependencias para rbenv/ruby-build)
sudo apt install -y libssl-dev libreadline-dev zlib1g-dev libyaml-dev \
  libffi-dev libgdbm-dev libncurses-dev

# Java
sudo apt install -y default-jdk maven

# Input e utilidades GNOME
sudo apt install -y fcitx5 file-roller baobab cheese shotwell


### Atuin (shell history com sync)
```bash
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
atuin login
atuin sync
```

### NVM + Node
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 22
nvm use 22
npm install -g @bazel/bazelisk corepack
```

### rbenv + Ruby
```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv install 3.4.7
rbenv global 3.4.7
gem install bundler rails
```

### uv (Python package manager)
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### pipx + ferramentas Python
```bash
sudo apt install -y pipx
pipx install aider-install
pipx install files-to-prompt
```

### Claude Code
```bash
npm install -g @anthropic-ai/claude-code
```

### Ghostty (terminal)
```bash
# Baixar de https://ghostty.org/download
```

### Bruno (API client)
```bash
# Baixar .deb de https://www.usebruno.com/downloads
```

### Espanso (text expander - versao Wayland)
```bash
# Baixar de https://espanso.org/install/
```
=> Configurar Atalhos ESPANSO (/dotfiles2)

### LocalSend
```bash
# Baixar de https://localsend.org/download
```



---

## 5. Dotfiles - Restaurar Configuracao

```bash
cd ~/code
git clone git@github.com:brpl20/dotfiles2.git

# Identidade da maquina
echo "debian" > ~/.machine

# Symlinks
ln -sf ~/code/dotfiles2/zshrc ~/.zshrc
ln -sf ~/code/dotfiles2/aliases/aliases-base ~/.aliases-base
ln -sf ~/code/dotfiles2/aliases/aliases-git ~/.aliases-git
ln -sf ~/code/dotfiles2/aliases/aliases-linux ~/.aliases-linux

# Espanso
mkdir -p ~/.config/espanso/match
ln -sf ~/code/dotfiles2/espanso/base.yml ~/.config/espanso/match/base.yml

# Shell padrao
chsh -s $(which zsh)
```

---

## 6. Git & SSH

```bash
git config --global user.name "Bruno Pellizzetti"
git config --global user.email "pelli.br@gmail.com"

# Restaurar chaves SSH do backup
cp -r /backup/.ssh ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Autenticar GitHub CLI
gh auth login
```

## 7. Clonar Repositorios (`~/code/`)

```bash
mkdir -p ~/code && cd ~/code

# Principal
git clone git@github.com:brpl20/ProcStudio.git
git clone git@github.com:brpl20/legendator-rails.git
git clone git@github.com:brpl20/seuAlfredo.git
git clone git@github.com:brpl20/pellizzetti-advogados-associados.git
git clone git@github.com:brpl20/previdenciaprivadasimulada.git
git clone git@github.com:brpl20/integracao-garantidora.git
git clone git@github.com:brpl20/quita-simples2.git
git clone git@github.com:brpl20/svelter.git
git clone git@github.com:brpl20/lawparser.git
git clone git@github.com:brpl20/crawlers.git
git clone git@github.com:brpl20/brpl-blog.git
git clone git@github.com:brpl20/contentMaker.git

## 8. Estrutura de Diretorios

```bash
mkdir -p ~/nc
mkdir -p ~/nc-dev
mkdir -p ~/odd
mkdir -p ~/Desktop
mkdir -p ~/Downloads
mkdir -p ~/DOWNLOADS
mkdir -p ~/code
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/fonts
```


## 11. Config do Atuin

```bash
# ~/.config/atuin/config.toml
cat <<'EOF' > ~/.config/atuin/config.toml
enter_accept = true

[sync]
records = true
EOF

atuin login
atuin sync
```
