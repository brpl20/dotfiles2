#!/bin/bash

# Git Ignore Generator Script
# Usage: gi (git init + gitignore) or gitignore (standalone)

# Dictionary of common languages and their corresponding GitHub gitignore files
declare -A GITIGNORE_DICT=(
    ["node"]="Node.gitignore"
    ["nodejs"]="Node.gitignore"
    ["javascript"]="Node.gitignore"
    ["js"]="Node.gitignore"
    ["python"]="Python.gitignore"
    ["py"]="Python.gitignore"
    ["ruby"]="Ruby.gitignore"
    ["rb"]="Ruby.gitignore"
    ["rails"]="Rails.gitignore"
    ["java"]="Java.gitignore"
    ["go"]="Go.gitignore"
    ["golang"]="Go.gitignore"
    ["rust"]="Rust.gitignore"
    ["c"]="C.gitignore"
    ["cpp"]="C++.gitignore"
    ["csharp"]="VisualStudio.gitignore"
    ["dotnet"]="VisualStudio.gitignore"
    ["php"]="PHP.gitignore"
    ["swift"]="Swift.gitignore"
    ["kotlin"]="Kotlin.gitignore"
    ["android"]="Android.gitignore"
    ["ios"]="Swift.gitignore"
    ["react"]="Node.gitignore"
    ["vue"]="Node.gitignore"
    ["angular"]="Node.gitignore"
    ["django"]="Python.gitignore"
    ["flask"]="Python.gitignore"
    ["laravel"]="PHP.gitignore"
    ["unity"]="Unity.gitignore"
    ["unreal"]="UnrealEngine.gitignore"
    ["wordpress"]="WordPress.gitignore"
    ["jekyll"]="Jekyll.gitignore"
    ["latex"]="TeX.gitignore"
    ["tex"]="TeX.gitignore"
    ["vim"]="Vim.gitignore"
    ["emacs"]="Emacs.gitignore"
    ["vscode"]="VisualStudioCode.gitignore"
    ["macos"]="macOS.gitignore"
    ["linux"]="Linux.gitignore"
    ["windows"]="Windows.gitignore"
)

# Function to check if fzf is installed
check_fzf() {
    if ! command -v fzf &> /dev/null; then
        echo "❌ fzf is not installed. Please install it first:"
        echo "   brew install fzf  # on macOS"
        echo "   sudo apt install fzf  # on Ubuntu/Debian"
        echo "   Or visit: https://github.com/junegunn/fzf#installation"
        return 1
    fi
    return 0
}

# Function to download gitignore file
download_gitignore() {
    local gitignore_file="$1"
    local url="https://raw.githubusercontent.com/github/gitignore/main/$gitignore_file"
    
    echo "📥 Downloading $gitignore_file..."
    echo "🔗 URL: $url"
    
    if command -v curl &> /dev/null; then
        local http_code
        http_code=$(curl -s -L -w "%{http_code}" "$url" -o .gitignore)
        
        if [ "$http_code" -eq 200 ] && [ -s .gitignore ]; then
            echo "✅ .gitignore file created successfully!"
            echo "📄 Applied gitignore template: $gitignore_file"
            return 0
        else
            echo "❌ Failed to download gitignore file. HTTP code: $http_code"
            echo "🔗 Tried URL: $url"
            rm -f .gitignore 2>/dev/null
            return 1
        fi
    elif command -v wget &> /dev/null; then
        if wget -q "$url" -O .gitignore; then
            if [ -s .gitignore ]; then
                echo "✅ .gitignore file created successfully!"
                echo "📄 Applied gitignore template: $gitignore_file"
                return 0
            fi
        fi
        echo "❌ Failed to download gitignore file."
        echo "🔗 Tried URL: $url"
        rm -f .gitignore 2>/dev/null
        return 1
    else
        echo "❌ Neither curl nor wget is available. Please install one of them."
        return 1
    fi
}

# Function to select language using fuzzy finder
select_language() {
    # Send messages to stderr so they don't interfere with the return value
    echo "🔍 Select language/framework for .gitignore:" >&2
    echo "   (Type to search, use arrows to navigate, Enter to select)" >&2
    echo "" >&2
    
    # Create a list of all keys for fzf
    local selected_key
    selected_key=$(printf '%s\n' "${!GITIGNORE_DICT[@]}" | sort | fzf \
        --height=15 \
        --layout=reverse \
        --border \
        --prompt="Language/Framework: " \
        --preview="echo 'Will use: ${GITIGNORE_DICT[{}]}'" \
        --preview-window=up:1)
    
    if [ -z "$selected_key" ]; then
        echo "❌ No language selected. Exiting." >&2
        return 1
    fi
    
    # Only output the selected key to stdout (this is what gets captured)
    echo "$selected_key"
    return 0
}

# Function to handle multiple language selection
select_multiple_languages() {
    # Send messages to stderr so they don't interfere with the return value
    echo "🔍 Select languages/frameworks for .gitignore:" >&2
    echo "   (Use TAB to select multiple, Enter to confirm)" >&2
    echo "" >&2
    
    local selected_keys
    selected_keys=$(printf '%s\n' "${!GITIGNORE_DICT[@]}" | sort | fzf \
        --multi \
        --height=15 \
        --layout=reverse \
        --border \
        --prompt="Languages/Frameworks (TAB to select): " \
        --preview="echo 'Will use: ${GITIGNORE_DICT[{}]}'" \
        --preview-window=up:1)
    
    if [ -z "$selected_keys" ]; then
        echo "❌ No languages selected. Exiting." >&2
        return 1
    fi
    
    # Only output the selected keys to stdout
    echo "$selected_keys"
    return 0
}

# Function to combine multiple gitignore files
combine_gitignores() {
    local selected_languages="$1"
    local temp_dir=$(mktemp -d)
    local combined_file="$temp_dir/combined.gitignore"
    
    echo "# Combined .gitignore file" > "$combined_file"
    echo "# Generated on $(date)" >> "$combined_file"
    echo "" >> "$combined_file"
    
    while IFS= read -r lang; do
        local gitignore_file="${GITIGNORE_DICT[$lang]}"
        local url="https://raw.githubusercontent.com/github/gitignore/main/$gitignore_file"
        
        echo "📥 Downloading $gitignore_file for $lang..."
        
        echo "# ========================================" >> "$combined_file"
        echo "# $lang ($gitignore_file)" >> "$combined_file"
        echo "# ========================================" >> "$combined_file"
        
        if command -v curl &> /dev/null; then
            curl -s -L "$url" >> "$combined_file"
        elif command -v wget &> /dev/null; then
            wget -q "$url" -O - >> "$combined_file"
        else
            echo "❌ Neither curl nor wget is available."
            rm -rf "$temp_dir"
            return 1
        fi
        
        echo "" >> "$combined_file"
        echo "" >> "$combined_file"
    done <<< "$selected_languages"
    
    # Move the combined file to the current directory
    mv "$combined_file" .gitignore
    rm -rf "$temp_dir"
    
    echo "✅ Combined .gitignore file created successfully!"
    echo "📄 Applied templates for: $(echo "$selected_languages" | tr '\n' ' ')"
    return 0
}

# Function for git init + gitignore (gi command)
gi() {
    if ! check_fzf; then
        return 1
    fi
    
    echo "🚀 Initializing new Git repository with .gitignore"
    echo ""
    
    # Initialize git repository
    git init
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to initialize git repository"
        return 1
    fi
    
    echo ""
    echo "Do you want to select multiple languages? (y/N)"
    read -r multiple_choice
    
    if [[ "$multiple_choice" =~ ^[Yy]$ ]]; then
        local selected_languages
        selected_languages=$(select_multiple_languages)
        
        if [ $? -ne 0 ]; then
            return 1
        fi
        
        combine_gitignores "$selected_languages"
    else
        local selected_language
        selected_language=$(select_language)
        
        if [ $? -ne 0 ] || [ -z "$selected_language" ]; then
            echo "❌ Language selection failed"
            return 1
        fi
        
        echo "🎯 Selected language: $selected_language"
        local gitignore_file="${GITIGNORE_DICT[$selected_language]}"
        echo "📋 Using template: $gitignore_file"
        
        if [ -z "$gitignore_file" ]; then
            echo "❌ No template found for: $selected_language"
            return 1
        fi
        
        download_gitignore "$gitignore_file"
    fi
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 Repository initialized successfully!"
        echo "📁 Current directory: $(pwd)"
        echo "📄 .gitignore file: $(wc -l < .gitignore) lines"
    fi
}

# Function for standalone gitignore (gitignore command)
gitignore() {
    if ! check_fzf; then
        return 1
    fi
    
    echo "📝 Adding .gitignore to existing repository"
    echo ""
    
    # Check if .gitignore already exists
    if [ -f .gitignore ]; then
        echo "⚠️  .gitignore already exists. Do you want to:"
        echo "   1) Overwrite it"
        echo "   2) Append to it"
        echo "   3) Cancel"
        read -p "Choose option (1/2/3): " choice
        
        case $choice in
            1)
                echo "🗑️  Overwriting existing .gitignore"
                ;;
            2)
                echo "➕ Will append to existing .gitignore"
                ;;
            3)
                echo "❌ Cancelled"
                return 0
                ;;
            *)
                echo "❌ Invalid choice. Cancelled"
                return 1
                ;;
        esac
    else
        choice=1  # Create new file
    fi
    
    echo ""
    echo "Do you want to select multiple languages? (y/N)"
    read -r multiple_choice
    
    if [[ "$multiple_choice" =~ ^[Yy]$ ]]; then
        local selected_languages
        selected_languages=$(select_multiple_languages)
        
        if [ $? -ne 0 ]; then
            return 1
        fi
        
        if [ "$choice" = "2" ]; then
            # Append mode
            echo "" >> .gitignore
            echo "# ========================================" >> .gitignore
            echo "# Additional patterns added on $(date)" >> .gitignore
            echo "# ========================================" >> .gitignore
            
            local temp_dir=$(mktemp -d)
            local temp_file="$temp_dir/temp.gitignore"
            
            while IFS= read -r lang; do
                local gitignore_file="${GITIGNORE_DICT[$lang]}"
                local url="https://raw.githubusercontent.com/github/gitignore/main/$gitignore_file"
                
                echo "📥 Downloading $gitignore_file for $lang..."
                
                echo "" >> .gitignore
                echo "# $lang ($gitignore_file)" >> .gitignore
                echo "# ========================================" >> .gitignore
                
                if command -v curl &> /dev/null; then
                    curl -s -L "$url" >> .gitignore
                elif command -v wget &> /dev/null; then
                    wget -q "$url" -O - >> .gitignore
                fi
            done <<< "$selected_languages"
            
            rm -rf "$temp_dir"
        else
            # Overwrite mode
            combine_gitignores "$selected_languages"
        fi
    else
        local selected_language
        selected_language=$(select_language)
        
        if [ $? -ne 0 ] || [ -z "$selected_language" ]; then
            echo "❌ Language selection failed"
            return 1
        fi
        
        echo "🎯 Selected language: $selected_language"
        local gitignore_file="${GITIGNORE_DICT[$selected_language]}"
        echo "📋 Using template: $gitignore_file"
        
        if [ -z "$gitignore_file" ]; then
            echo "❌ No template found for: $selected_language"
            return 1
        fi
        
        if [ "$choice" = "2" ]; then
            # Append mode
            echo "" >> .gitignore
            echo "# ========================================" >> .gitignore
            echo "# Additional $selected_language patterns added on $(date)" >> .gitignore
            echo "# ========================================" >> .gitignore
            
            local url="https://raw.githubusercontent.com/github/gitignore/main/$gitignore_file"
            echo "🔗 Appending from: $url"
            
            if command -v curl &> /dev/null; then
                local http_code
                http_code=$(curl -s -L -w "%{http_code}" "$url" >> .gitignore)
                if [ "$http_code" -ne 200 ]; then
                    echo "❌ Failed to append. HTTP code: $http_code"
                    return 1
                fi
            elif command -v wget &> /dev/null; then
                if ! wget -q "$url" -O - >> .gitignore; then
                    echo "❌ Failed to append patterns"
                    return 1
                fi
            fi
            
            echo "✅ Patterns appended to .gitignore successfully!"
        else
            # Overwrite mode
            download_gitignore "$gitignore_file"
        fi
    fi
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "📄 .gitignore file: $(wc -l < .gitignore) lines"
        echo "📁 Location: $(pwd)/.gitignore"
    fi
}

# Export functions to make them available as commands
export -f gi
export -f gitignore

# Detect how the script was called and execute appropriate function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Get the basename of how the script was called
    script_name=$(basename "$0")
    
    case "$script_name" in
        "gi"|"gi.sh")
            gi "$@"
            ;;
        "gitignore"|"gitignore.sh"|"git_ignore_generator.sh")
            if [[ "$1" == "init" ]]; then
                gi "${@:2}"
            else
                gitignore "$@"
            fi
            ;;
        *)
            echo "Git Ignore Generator"
            echo "Usage:"
            echo "  gi        - Initialize git repo with .gitignore"
            echo "  gitignore - Add .gitignore to existing repo"
            echo ""
            echo "Current setup method:"
            echo "  alias gi='$0'"
            echo "  alias gitignore='$0'"
            ;;
    esac
fi