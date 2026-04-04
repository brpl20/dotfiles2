#!/bin/bash
# Startup script: waits for BPSSD volume, starts Syncthing + Excalidraw
# Location: /Users/brpl/code/dotfiles2/mac_scripts/brewhd_syncthing.sh
# LaunchAgent: ~/Library/LaunchAgents/com.brpl.brewhd-startup.plist

LOG_FILE="/Users/brpl/Library/Logs/brewhd_syncthing.log"
BPSSD="/Volumes/BPSSD"
BREW_BIN="$BPSSD/Aplicativos-HomeBrew/bin"
SYNCTHING_BIN="$BPSSD/Aplicativos-HomeBrew/opt/syncthing/bin/syncthing"
EXCALIDRAW_DIR="/Users/brpl/code/excalidraw"
MAX_WAIT=300  # 5 minutes max
INTERVAL=5

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

notify() {
    osascript -e "display notification \"$1\" with title \"$2\"" 2>/dev/null
}

# --- Wait for BPSSD ---
log "=== Startup script triggered ==="
waited=0

while [ ! -d "$BPSSD" ]; do
    if [ "$waited" -ge "$MAX_WAIT" ]; then
        log "BPSSD not found after ${MAX_WAIT}s — aborting"
        notify "BPSSD not found after ${MAX_WAIT}s" "Startup Failed"
        exit 1
    fi
    log "Waiting for BPSSD... (${waited}s/${MAX_WAIT}s)"
    sleep "$INTERVAL"
    waited=$((waited + INTERVAL))
done

log "BPSSD detected after ${waited}s"
export PATH="$BREW_BIN:$PATH"

# --- Syncthing ---
if pgrep -f "syncthing" > /dev/null; then
    log "Syncthing already running — skipping"
else
    log "Starting Syncthing..."
    nohup "$SYNCTHING_BIN" -no-browser >> "$LOG_FILE" 2>&1 &
    disown
    sleep 5
    if curl -s --max-time 5 http://localhost:8384 > /dev/null; then
        log "Syncthing started OK"
        notify "Syncthing started" "BPSSD Startup"
    else
        log "Syncthing failed to respond on :8384"
        notify "Syncthing failed to start" "BPSSD Startup"
    fi
fi

# --- Excalidraw ---
if lsof -i :5233 > /dev/null 2>&1; then
    log "Excalidraw already running on :5233 — skipping"
else
    log "Starting Excalidraw..."
    cd "$EXCALIDRAW_DIR"
    nohup /opt/homebrew/bin/yarn start >> "$LOG_FILE" 2>&1 &
    EXCALIDRAW_PID=$!
    disown $EXCALIDRAW_PID

    # Wait for vite dev server to come up
    exc_waited=0
    while [ "$exc_waited" -lt 60 ]; do
        sleep 3
        exc_waited=$((exc_waited + 3))
        if lsof -i :5233 > /dev/null 2>&1; then
            log "Excalidraw started OK on :5233 (PID $EXCALIDRAW_PID)"
            notify "Excalidraw running on localhost:5233" "BPSSD Startup"
            break
        fi
    done

    if [ "$exc_waited" -ge 60 ]; then
        log "Excalidraw did not start within 60s"
        notify "Excalidraw failed to start" "BPSSD Startup"
    fi
fi

log "=== Startup complete ==="
