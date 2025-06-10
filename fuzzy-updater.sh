#!/bin/bash

# Automatic Folder Indexer - Watches base directories and updates bookmarks
# Usage: ./folder_watcher.sh

# Configuration
BOOKMARKS_FILE="$HOME/.folder_bookmarks"
CONFIG_FILE="$HOME/.folder_watcher_config"
WATCH_DIRS_FILE="$HOME/.watch_directories"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Create default config if it doesn't exist
create_default_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" << 'EOF'
# Folder Watcher Configuration
MAX_DEPTH=3
EXCLUDE_HIDDEN=true
EXCLUDE_PATTERNS=".git|node_modules|.Trash|Library/Caches"
UPDATE_INTERVAL=30  # seconds between checks (fallback)
EOF
        echo -e "${GREEN}Created default config at $CONFIG_FILE${NC}"
    fi
}

# Create default watch directories if they don't exist
create_default_watch_dirs() {
    if [[ ! -f "$WATCH_DIRS_FILE" ]]; then
        cat > "$WATCH_DIRS_FILE" << EOF
# Base directories to watch (one per line)
# Edit this file to add your important base folders
$HOME/Documents
$HOME/Desktop
$HOME/Downloads
/Users/brpl20/Library/CloudStorage/GoogleDrive-pelli.br@gmail.com/Meu Drive
EOF
        echo -e "${GREEN}Created watch directories file at $WATCH_DIRS_FILE${NC}"
        echo -e "${YELLOW}Edit $WATCH_DIRS_FILE to add your base folders${NC}"
    fi
}

# Load configuration
load_config() {
    source "$CONFIG_FILE"
}

# Generate folder list from watched directories
generate_folder_list() {
    local temp_file=$(mktemp)
    
    while IFS= read -r base_dir; do
        # Skip comments and empty lines
        [[ "$base_dir" =~ ^#.*$ ]] && continue
        [[ -z "$base_dir" ]] && continue
        
        # Skip if directory doesn't exist
        [[ ! -d "$base_dir" ]] && continue
        
        # Build find command
        local find_cmd="find '$base_dir' -maxdepth $MAX_DEPTH -type d"
        
        if [[ "$EXCLUDE_HIDDEN" == "true" ]]; then
            find_cmd="$find_cmd -not -path '*/.*'"
        fi
        
        # Add exclusion patterns
        if [[ -n "$EXCLUDE_PATTERNS" ]]; then
            IFS='|' read -ra patterns <<< "$EXCLUDE_PATTERNS"
            for pattern in "${patterns[@]}"; do
                find_cmd="$find_cmd -not -path '*/$pattern/*'"
            done
        fi
        
        # Execute and append to temp file
        eval $find_cmd 2>/dev/null >> "$temp_file"
        
    done < "$WATCH_DIRS_FILE"
    
    # Sort and remove duplicates
    sort "$temp_file" | uniq > "$BOOKMARKS_FILE"
    rm "$temp_file"
    
    local count=$(wc -l < "$BOOKMARKS_FILE")
    echo -e "${GREEN}Updated bookmarks: $count folders indexed${NC}"
}

# Watch using fswatch (if available) or fallback to polling
start_watching() {
    echo -e "${BLUE}Starting folder watcher...${NC}"
    
    # Check if fswatch is available
    if command -v fswatch >/dev/null 2>&1; then
        echo -e "${GREEN}Using fswatch for real-time monitoring${NC}"
        
        # Build watch command for all directories
        local watch_dirs=()
        while IFS= read -r base_dir; do
            [[ "$base_dir" =~ ^#.*$ ]] && continue
            [[ -z "$base_dir" ]] && continue
            [[ -d "$base_dir" ]] && watch_dirs+=("$base_dir")
        done < "$WATCH_DIRS_FILE"
        
        if [[ ${#watch_dirs[@]} -eq 0 ]]; then
            echo -e "${YELLOW}No valid directories to watch. Check $WATCH_DIRS_FILE${NC}"
            exit 1
        fi
        
        # Initial generation
        generate_folder_list
        
        # Watch for changes
        fswatch -r "${watch_dirs[@]}" | while read file; do
            echo -e "${YELLOW}Change detected: $file${NC}"
            generate_folder_list
        done
        
    else
        echo -e "${YELLOW}fswatch not found. Install with: brew install fswatch${NC}"
        echo -e "${YELLOW}Falling back to polling mode (every $UPDATE_INTERVAL seconds)${NC}"
        
        # Initial generation
        generate_folder_list
        
        # Polling loop
        while true; do
            sleep "$UPDATE_INTERVAL"
            generate_folder_list
        done
    fi
}

# Show help
show_help() {
    echo "Automatic Folder Indexer"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start       Start watching directories (default)"
    echo "  update      Update bookmarks once and exit"
    echo "  config      Edit configuration file"
    echo "  dirs        Edit watched directories"
    echo "  status      Show current status"
    echo "  help        Show this help"
    echo ""
    echo "Files:"
    echo "  Config: $CONFIG_FILE"
    echo "  Watch dirs: $WATCH_DIRS_FILE"
    echo "  Bookmarks: $BOOKMARKS_FILE"
}

# Main logic
case "${1:-start}" in
    start)
        create_default_config
        create_default_watch_dirs
        load_config
        start_watching
        ;;
    update)
        create_default_config
        create_default_watch_dirs
        load_config
        generate_folder_list
        ;;
    config)
        ${EDITOR:-nano} "$CONFIG_FILE"
        ;;
    dirs)
        ${EDITOR:-nano} "$WATCH_DIRS_FILE"
        ;;
    status)
        echo "Configuration: $CONFIG_FILE"
        echo "Watch dirs: $WATCH_DIRS_FILE" 
        echo "Bookmarks: $BOOKMARKS_FILE"
        [[ -f "$BOOKMARKS_FILE" ]] && echo "Indexed folders: $(wc -l < "$BOOKMARKS_FILE")"
        ;;
    help)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
