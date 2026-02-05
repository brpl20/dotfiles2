# zshrc - Single entry point for all machines
# Setup: echo "macbook" > ~/.machine && ln -sf ~/code/dotfiles2/zshrc ~/.zshrc

# --- Oh My Zsh ---
ZSH=$HOME/.oh-my-zsh
if [[ -d "$ZSH" ]]; then
  ZSH_THEME="robbyrussell"
  plugins=(git gitfast last-working-dir common-aliases sublime history-substring-search pyenv ssh-agent)
  source "${ZSH}/oh-my-zsh.sh"
  unalias rm 2>/dev/null
fi

# --- PATH ---
export PATH="./bin:./node_modules/.bin:${HOME}/.rbenv/bin:${HOME}/.pyenv/bin:${HOME}/.local/bin:${PATH}:/usr/local/sbin"

# --- Encoding ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# --- Version managers ---

# rbenv
type -a rbenv &>/dev/null && eval "$(rbenv init -)"

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv &>/dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use --silent
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default --silent
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# atuin
[[ -f "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"
export PATH="$HOME/.atuin/bin:$PATH"
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# fzf
command -v fzf &>/dev/null && source <(fzf --zsh) 2>/dev/null

# starship
command -v starship &>/dev/null && eval "$(starship init zsh)"

# --- Machine identity ---
# Resolve symlink to find dotfiles repo (works on macOS and Linux)
if [[ -L ~/.zshrc ]]; then
  DOTFILES="$(cd "$(dirname "$(readlink ~/.zshrc)")" && pwd)"
else
  DOTFILES="$HOME"
fi
MACHINE="$(cat ~/.machine 2>/dev/null)"

# --- Machine layer (sets EDITOR, CODEF, GD, etc.) ---
if [[ -n "$MACHINE" && -f "$DOTFILES/machines/$MACHINE" ]]; then
  source "$DOTFILES/machines/$MACHINE"
else
  echo "Warning: ~/.machine not set or machines/$MACHINE not found"
fi

# --- OS layer (uses variables from machine layer) ---
case "$(uname)" in
  Darwin) [[ -f "$DOTFILES/os/darwin" ]] && source "$DOTFILES/os/darwin" ;;
  Linux)  [[ -f "$DOTFILES/os/linux" ]]  && source "$DOTFILES/os/linux" ;;
esac

# --- Aliases ---
[[ -f "$DOTFILES/aliases/aliases-base" ]] && source "$DOTFILES/aliases/aliases-base"
[[ -f "$DOTFILES/aliases/aliases-git" ]]  && source "$DOTFILES/aliases/aliases-git"

echo "Ola Bruno! Nao se esqueca de fazer esse o melhor dia de sua vida! Memento Mori"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
