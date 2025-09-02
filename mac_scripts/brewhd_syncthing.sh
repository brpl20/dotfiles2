#!/bin/bash
# Script to run when BPSSD volume is mounted
# Location: /Users/brpl/code/dotfiles2/mac_scripts/brewhd_syncthing.sh

# Log file for debugging
LOG_FILE="/Users/brpl/Library/Logs/brewhd_syncthing.log"

# Log function
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

log_message "Script triggered - checking for BPSSD volume"

# Check if the volume is actually mounted
if [ -d "/Volumes/BPSSD" ]; then
    log_message "BPSSD volume detected"

    # Update PATH to include HomeBrew binaries from the external volume
    export PATH="/Volumes/BPSSD/Aplicativos-HomeBrew/bin:$PATH"
    log_message "PATH updated to include: /Volumes/BPSSD/Aplicativos-HomeBrew/bin"

    # Check if Syncthing is already running
    if pgrep -f "syncthing serve" > /dev/null; then
        log_message "Syncthing is already running"
        osascript -e 'display notification "Syncthing is already running" with title "BPSSD Volume Mounted"'
    else
        # Start Syncthing in background
        log_message "Starting Syncthing..."
        syncthing serve --no-browser &

        # Wait for Syncthing to start and verify it's running
        sleep 3
        if curl -s http://localhost:8384 > /dev/null; then
            log_message "✅ Syncthing started successfully"
            osascript -e 'display notification "Syncthing started successfully" with title "BPSSD Volume Mounted"'
        else
            log_message "❌ Syncthing failed to start"
            osascript -e 'display notification "Syncthing failed to start" with title "BPSSD Volume Mounted" subtitle "Check logs for details"'
        fi
    fi
else
    log_message "BPSSD volume not found at /Volumes/BPSSD"
fi
