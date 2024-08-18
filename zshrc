# Detect the operating system
os_type=$(uname)

ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases sublime history-substring-search pyenv ssh-agent)

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PATH="${HOME}/.pyenv/bin:${PATH}" # Needed for Linux/WSL
export PYENV_VIRTUALENV_DISABLE_PROMPT=1 # https://github.com/pyenv/pyenv-virtualenv/issues/135
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv_prompt_info)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
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

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BUNDLER_EDITOR="subl $@ >/dev/null 2>&1 -a"
export BUNDLER_EDITOR="subl $@ >/dev/null 2>&1 -a"
export BUNDLER_EDITOR="subl $@ >/dev/null 2>&1 -a"
export BUNDLER_EDITOR="subl $@ >/dev/null 2>&1 -a"
export BUNDLER_EDITOR="subl $@ >/dev/null 2>&1 -a"
export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' -a"
export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' -a"

eval "$(atuin init zsh)"

# Aliases for macOS-specific aliases
if [ "$os_type" = "Darwin" ]; then
  [[ -f "$HOME/.aliases-mac" ]] && source "$HOME/.aliases-mac" || echo "Error: $HOME/.aliases-mac not found."
fi

# Aliases macOS-specific aliases
if [ "$os_type" = "Darwin" ]; then
  export GD="/Users/brpl20/Library/CloudStorage/GoogleDrive-pelli.br@gmail.com/Meu\ Drive"
  export ESPANSO="/Users/brpl20/Library/Application\ Support/espanso/match"
  export OD="/Users/brpl20/Library/CloudStorage/OneDrive-Pessoal"
  export CODEF="/Users/brpl20/code"
  export DESK="/Users/brpl20/Desktop"
  export DOWN="/Users/brpl20/Downloads"
  # source /Users/brpl20/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  # source /Users/brpl20/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
  export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"
  export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
  export HOMEBREW_NO_ANALYTICS=1
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  echo "Mac!"
fi

# Aliases Linux-specific aliases
if [ "$os_type" = "Linux" ]; then
  export GD="/home/brpl/gd"
  export ESPANSO="/espanso-TODO"
  export OD="/home/brpl/od"
  export CODEF="/home/brpl/code"
  export DESK="/home/brpl/Desktop"
  export DOWN="/home/brpl/Downloads"
  source /home/brpl/code/dotfiles2/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ALIASES-BASE (LINUX AND MAC)
[[ -f "$HOME/.aliases-base" ]] && source "$HOME/.aliases-base" || echo "Error: $HOME/.aliases-base not found."


# Aliases for Linux-specific aliases
if [ "$os_type" = "Linux" ]; then
  [[ -f "$HOME/.aliases-linux" ]] && source "$HOME/.aliases-linux" || echo "Error: $HOME/.aliases-linux not found."
fi

echo "Olá Bruno! Não se equeça de fazer esse o melhor dia de sua vida! Memento Mori"