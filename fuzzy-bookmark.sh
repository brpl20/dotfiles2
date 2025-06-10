# Enhanced FZF Folder Navigation Functions
# Add these to your ~/.zshrc or ~/.bashrc

# Main folder bookmarks function with full-screen interface
fb() {
    local dir result
    
    # Use a temporary file to handle the tab action
    local temp_action=$(mktemp)
    
    dir=$(cat ~/.folder_bookmarks 2>/dev/null | fzf \
        --preview 'ls -la --color=always {} 2>/dev/null | head -50' \
        --preview-window 'right:50%:wrap' \
        --height '100%' \
        --border \
        --header 'Enter: cd | Ctrl+O: Finder | Tab: browse files' \
        --bind "ctrl-o:execute(open {})" \
        --bind "tab:execute(echo 'browse_files:{}' > $temp_action)+abort" \
        --color 'header:italic:underline,info:green')
    
    # Check if user pressed Tab (browse files action)
    if [[ -f "$temp_action" ]] && [[ -s "$temp_action" ]]; then
        local action_content=$(cat "$temp_action")
        rm -f "$temp_action"
        
        if [[ "$action_content" =~ ^browse_files:(.+)$ ]]; then
            local folder_path="${BASH_REMATCH[1]}"
            echo "🔍 Browsing files in: $folder_path"
            fb_files "$folder_path"
            return
        fi
    fi
    
    rm -f "$temp_action"
    
    # Normal cd action
    if [[ -n "$dir" ]]; then
        cd "$dir"
        echo "📁 Navigated to: $(pwd)"
        ls -la
    fi
}

# File browser within selected folder
fb_files() {
    local base_dir="$1"
    local selected_file
    
    if [[ ! -d "$base_dir" ]]; then
        echo "Error: Directory not found: $base_dir"
        return 1
    fi
    
    echo "📂 Browsing files in: $base_dir"
    
    selected_file=$(find "$base_dir" -maxdepth 2 \( -type f -o -type d \) 2>/dev/null | fzf \
        --preview 'if [[ -d {} ]]; then
                     echo "📁 Directory: {}" && echo "" && ls -la {} 2>/dev/null | head -20
                   elif [[ -f {} ]]; then
                     echo "📄 File: {}" && echo ""
                     if file {} | grep -q "text\|ASCII\|UTF-8"; then
                         head -30 {} 2>/dev/null
                     else
                         file {} && echo "" && ls -la {} 2>/dev/null
                     fi
                   fi' \
        --preview-window 'right:60%:wrap' \
        --height '100%' \
        --border \
        --header "📁 $(basename "$base_dir") | Enter: open | Ctrl+E: edit | Ctrl+B: back to folders" \
        --bind 'ctrl-e:execute($EDITOR {})' \
        --bind 'ctrl-b:execute(fb)+abort' \
        --bind 'ctrl-o:execute(open {})' \
        --color 'header:italic:underline,info:blue')
    
    if [[ -n "$selected_file" ]]; then
        if [[ -d "$selected_file" ]]; then
            # If it's a directory, cd into it
            cd "$selected_file"
            echo "📁 Navigated to: $(pwd)"
            ls -la
        elif [[ -f "$selected_file" ]]; then
            # If it's a file, auto-detect what to do
            if file "$selected_file" | grep -q "text\|ASCII\|UTF-8"; then
                ${EDITOR:-nano} "$selected_file"
            else
                open "$selected_file"
            fi
        fi
    fi
}

# Quick Finder opener (fixed version)
fo() {
    local dir
    dir=$(cat ~/.folder_bookmarks 2>/dev/null | fzf \
        --preview 'ls -la --color=always {} 2>/dev/null | head -50' \
        --preview-window 'right:50%:wrap' \
        --height '100%' \
        --border \
        --header 'Select folder to open in Finder' \
        --color 'header:italic:underline,info:green')
    
    if [[ -n "$dir" ]]; then
        open "$dir"
        echo "🍎 Opened in Finder: $dir"
    fi
}

# Enhanced version with multiple actions
fbx() {
    local dir action
    
    # First select the folder
    dir=$(cat ~/.folder_bookmarks 2>/dev/null | fzf \
        --preview 'ls -la --color=always {} 2>/dev/null | head -50' \
        --preview-window 'right:45%:wrap' \
        --height '100%' \
        --border \
        --header 'Select folder first' \
        --color 'header:italic:underline,info:green')
    
    [[ -z "$dir" ]] && return
    
    # Then choose action
    action=$(echo -e "cd\t\t\tNavigate to folder in terminal\nfinder\t\tOpen folder in Finder\nfiles\t\tBrowse files in folder\nvscode\t\tOpen folder in VS Code\nterminal\t\tOpen new terminal in folder" | fzf \
        --delimiter '\t' \
        --with-nth 1,3 \
        --preview "echo 'Selected folder: $dir'" \
        --preview-window 'up:3:wrap' \
        --height '50%' \
        --border \
        --header "Choose action for: $(basename "$dir")" \
        --color 'header:italic:underline,info:yellow')
    
    case "$(echo "$action" | cut -f1)" in
        "cd")
            cd "$dir"
            echo "📁 Navigated to: $(pwd)"
            ls -la
            ;;
        "finder")
            open "$dir"
            echo "🍎 Opened in Finder: $dir"
            ;;
        "files")
            fb_files "$dir"
            ;;
        "vscode")
            if command -v code >/dev/null 2>&1; then
                code "$dir"
                echo "💻 Opened in VS Code: $dir"
            else
                echo "❌ VS Code not found"
            fi
            ;;
        "terminal")
            if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
                osascript -e "tell application \"iTerm\" to create window with default profile command \"cd '$dir'\""
            else
                osascript -e "tell application \"Terminal\" to do script \"cd '$dir'\""
            fi
            echo "🖥️ Opened new terminal in: $dir"
            ;;
    esac
}

# Quick aliases for convenience
alias f='fb'          # Quick folder navigation
alias ff='fb_files'   # Quick file browser
alias fh='fo'         # Quick Finder opener
alias fx='fbx'        # Extended actions

# Auto-completion for folder bookmarks
_fb_completion() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    if [[ -f ~/.folder_bookmarks ]]; then
        COMPREPLY=( $(compgen -W "$(cat ~/.folder_bookmarks)" -- "$cur") )
    fi
}

complete -F _fb_completion fb fo fbx

echo "🚀 Enhanced folder navigation loaded!"
echo "Commands: fb, fo, fbx, f, ff, fh, fx"
