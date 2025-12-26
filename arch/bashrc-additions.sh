#!/bin/bash
# Bash additions for Arch Linux
# Source this file from your ~/.bashrc (AFTER the Omarchy defaults)
#
# Add this line to your ~/.bashrc:
#   source ~/code/dotfiles2/arch/bashrc-additions.sh

# =============================================================================
# PATH ADDITIONS
# =============================================================================

# Add local bin directories to PATH (if not already present)
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Atuin path (if installed)
[[ -d "$HOME/.atuin/bin" ]] && export PATH="$HOME/.atuin/bin:$PATH"

# =============================================================================
# HISTORY SETTINGS
# =============================================================================

export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# =============================================================================
# SHELL OPTIONS
# =============================================================================

# Auto-cd: type directory name to cd into it
shopt -s autocd 2>/dev/null

# Correct minor spelling errors in cd
shopt -s cdspell

# Extended globbing
shopt -s extglob

# Pattern ** matches all files and directories recursively
shopt -s globstar 2>/dev/null

# Case-insensitive globbing
shopt -s nocaseglob

# Check window size after each command
shopt -s checkwinsize

# =============================================================================
# COMPLETION SETTINGS
# =============================================================================

# Enable bash completion if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
fi

# Case-insensitive completion
bind "set completion-ignore-case on"

# Show all completions on first tab
bind "set show-all-if-ambiguous on"

# Add trailing slash to symlinked directories
bind "set mark-symlinked-directories on"

# Color files by type in completion
bind "set colored-stats on"

# =============================================================================
# KEY BINDINGS
# =============================================================================

# Ctrl+Left/Right to move by word
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

# =============================================================================
# FZF INTEGRATION
# =============================================================================

if command -v fzf &> /dev/null; then
    # Source fzf key bindings and completion
    [[ -f /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
    [[ -f /usr/share/fzf/completion.bash ]] && source /usr/share/fzf/completion.bash

    # FZF options
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

    # Use fd if available (faster than find)
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
fi

# =============================================================================
# ATUIN (Better shell history)
# =============================================================================

if [[ -f "$HOME/.atuin/bin/env" ]]; then
    source "$HOME/.atuin/bin/env"
fi

if command -v atuin &> /dev/null; then
    eval "$(atuin init bash)"
fi

# =============================================================================
# STARSHIP PROMPT
# =============================================================================

if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# =============================================================================
# NPM/NODE UTILITIES
# =============================================================================

# Start dev server and open browser
npd() {
    local port=${1:-5173}
    npm run dev &
    sleep 3
    xdg-open "http://localhost:$port" 2>/dev/null
    wait
}

# =============================================================================
# SOURCE CUSTOM ALIASES
# =============================================================================

# Source base aliases (symlinked from dotfiles2)
[[ -f "$HOME/.aliases-base" ]] && source "$HOME/.aliases-base"

# Source git aliases
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/code/dotfiles2/arch}"

[[ -f "$DOTFILES_DIR/aliases-git.sh" ]] && source "$DOTFILES_DIR/aliases-git.sh"
[[ -f "$DOTFILES_DIR/aliases-linux.sh" ]] && source "$DOTFILES_DIR/aliases-linux.sh"
