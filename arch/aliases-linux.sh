#!/bin/bash
# Linux Aliases for Arch Linux - Adapted from aliases-base and aliases-mac
# Source this file from your ~/.bashrc

# =============================================================================
# DIRECTORY VARIABLES - CUSTOMIZE THESE FOR YOUR SETUP
# =============================================================================
export CODEF="$HOME/code"
export DESK="$HOME/Desktop"
export DOWN="$HOME/Downloads"
export GD="$HOME/gdrive"           # Synced files location
export OD="$HOME/onedrive"         # OneDrive location (if used)
export ESPANSO="$HOME/.config/espanso/match"

# =============================================================================
# NAVIGATION - cd shortcuts
# =============================================================================
alias '~'='cd ~'
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'
alias 'cd..'='cd ..'

# Single dot to go up (NOTE: this shadows the source command '.')
# If you need 'source', use 'source' explicitly instead of '.'
alias '.'='cd ..'

# =============================================================================
# CLIPBOARD UTILITIES (Wayland vs X11)
# =============================================================================
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    alias pwdc='pwd | wl-copy && echo "Path copied to clipboard"'
    _clip_copy() { wl-copy; }
    _clip_paste() { wl-paste; }
else
    alias pwdc='pwd | xclip -selection clipboard && echo "Path copied to clipboard"'
    _clip_copy() { xclip -selection clipboard; }
    _clip_paste() { xclip -selection clipboard -o; }
fi

# =============================================================================
# SEARCH UTILITIES
# =============================================================================
search_term_in_my_file() {
    local file="$GD/wikit/daily/uteisNew.md"
    if [[ ! -f "$file" ]]; then
        echo "File not found: $file"
        return 1
    fi
    if [[ "$1" == "#" ]]; then
        awk -v term="# $2" '
        BEGIN { IGNORECASE = 1 }
        $0 ~ "^" term {
            found = 1
            print
            next
        }
        found && NF {
            print
            next
        }
        found && !NF {
            found = 0
        }
        ' "$file" | tee >(_clip_copy)
    else
        grep -i "$1" "$file" | awk -F'=> ' '{print $2}' | awk '{print $1}' | _clip_copy
        grep -i "$1" "$file"
    fi
}
alias ss="search_term_in_my_file"

# =============================================================================
# SYSTEM / CONFIG
# =============================================================================
alias myip="curl https://ipinfo.io/json"
alias zshconfig="\${EDITOR:-code} ~/.zshrc"
alias bashconfig="\${EDITOR:-code} ~/.bashrc"

# =============================================================================
# SERVERS
# =============================================================================
alias h1="ssh brpl@168.231.90.14"
alias h2="ssh brpl@168.231.91.47"
alias h3="ssh brpl@212.85.13.30"

# =============================================================================
# CODING - Rails
# =============================================================================
alias rs3="rails s -p 3001"
alias rs="rails s"
alias rc="rails c"
alias rdb="rails db:migrate"
alias rdbd="rails db:drop"
alias rdbc="rails db:create"
alias rdbs="rails db:seed"
alias rdreset="rails db:drop && rails db:create && rails db:migrate && rails db:seed"

# =============================================================================
# CODING - Ruby / Python / Node
# =============================================================================
alias rb="ruby"
alias py="python3"
alias pip="pip3"
alias venv="python3 -m venv ."
alias npi="npm install"
alias npmb="npm run build"
alias npms="npm run dev"

# =============================================================================
# MKDIR AND CD INTO
# =============================================================================
mkcd() { mkdir -p "$1" && cd "$1"; }

# =============================================================================
# APPS - Open with editor/file manager
# =============================================================================
alias 'c.'='code .'
alias 'z.'='zed .'
alias 'o.'='xdg-open .'
alias o='xdg-open'
alias open='xdg-open'

# =============================================================================
# FILE LISTING
# =============================================================================
alias ls='ls --color=auto'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lla='ls -lah'
alias lsa='ls -lah'
alias fall='find . -iname'

# Case-insensitive search in ls output
lg() { ll -a | grep -i "$@"; }
# Case-sensitive search in ls output
lG() { ll -a | grep "$@"; }

# Use eza if available
if command -v eza &> /dev/null; then
    alias ls='eza --color=auto --icons'
    alias l='eza -lah --icons'
    alias la='eza -lAh --icons'
    alias ll='eza -lh --icons'
    alias lla='eza -lah --icons'
    alias tree='eza --tree --icons'
fi

# =============================================================================
# FUZZY + OPEN
# =============================================================================
fopen() {
    local file
    file=$(fzf)
    if [[ -n "$file" ]]; then
        xdg-open "$file"
    fi
}

# =============================================================================
# ALIASES AND CONFIG EDITING
# =============================================================================
alias cataliases="cat \$HOME/.aliases-base 2>/dev/null || cat \$CODEF/dotfiles2/arch/aliases-linux.sh"
alias edaliases="cd \$CODEF/dotfiles2 && \${EDITOR:-vim} \$CODEF/dotfiles2/arch/aliases-linux.sh"
alias catespanso="cat \$ESPANSO/base.yml"
alias edespanso="code \$ESPANSO/base.yml"
alias eduteis="code \$GD/wikit/daily/uteisNew.md"

# =============================================================================
# LOCATION SHORTCUTS
# =============================================================================
alias gd="cd \$GD"
alias od="cd \$OD"
alias wi="cd \$GD/wikit"
alias daily="code \$GD/wikit"
alias uteis="vim \$GD/wikit/daily/uteisNew.md"
alias cf="cd \$CODEF"
alias codef="cd \$CODEF"
alias n8n="cd \$GD/n8n"

# =============================================================================
# PROCSTUDIO
# =============================================================================
alias prc="cd \$CODEF/ProcStudio"
alias prcf="cd \$CODEF/ProcStudio/frontend"
alias prct="cd \$CODEF/ProcStudio/tests"
alias prcb="cd \$CODEF/procstudio_blog"
alias prcd="cd \$CODEF/ProcStudio/docs"

# ProcStudioIA
alias prcia="cd \$CODEF/ProcStudioIA"
alias prclab="cd \$CODEF/procstudio_ia_components_lab"

# ProcStudio APIS/Scrapers
alias prcld="cd \$CODEF/legal_data_api"
alias prcoab="cd \$CODEF/oab_sa"
alias prcocr="cd \$CODEF/procstudio_ocr"

# =============================================================================
# BRPL BLOG
# =============================================================================
alias blog="code \$CODEF/brpl-blog/_posts"
alias blogf="cd \$CODEF/brpl-blog"
alias blogup="sh \$CODEF/brpl-blog/gitup.sh"

# Advocacia
alias blogadv="cd \$CODEF/sftown-pellizzetti-associados-fe"
blogart() {
    touch "${1}.mdx" && cat "\$CODEF/dotfiles2/headermdx.txt" > "${1}.mdx"
    echo "The file ${1}.mdx has been created."
}

# =============================================================================
# DOTFILES
# =============================================================================
alias dot="cd \$CODEF/dotfiles2"

# =============================================================================
# UTILITIES / PROJECTS
# =============================================================================
alias wab="cd \$CODEF/whatsbot"
alias wao="cd \$CODEF/whats-organizer"
alias wap="cd \$CODEF/wap-uteis"
alias crw="cd \$CODEF/crawling"
alias oab="cd \$CODEF/oab_ocr"

alias desk="cd \$DESK"
alias down="cd \$DOWN"

# =============================================================================
# COMMANDS / SCRIPTS
# =============================================================================
alias sst="syncthing"
alias cpf="node ~/code/ProcStudio/tests/helpers/cpf_generator.js"
alias cnpj="node ~/code/ProcStudio/tests/helpers/cnpj_generator.js"

s3last() {
    local count=${1:-2}
    aws s3 ls s3://prcstudio3herokubucket/ --recursive | sort | tail -n "$count"
}

alias swap="sh \$GD/lztforeverfiles/aws_swap.sh"

# =============================================================================
# PACKAGE MANAGEMENT (Arch)
# =============================================================================
alias pacs='pacman -Ss'
alias paci='sudo pacman -S'
alias pacr='sudo pacman -Rs'
alias pacu='sudo pacman -Syu'
alias pacq='pacman -Qi'

if command -v yay &> /dev/null; then
    alias yays='yay -Ss'
    alias yayi='yay -S'
    alias yayu='yay -Syu'
fi

# =============================================================================
# MISC
# =============================================================================
alias c='clear'
alias cls='clear'
alias grep='grep --color=auto'
alias psg='ps aux | grep -v grep | grep'
alias duh='du -h --max-depth=1 | sort -h'
alias ports='ss -tulanp'
alias reload='source ~/.bashrc'
