#!/bin/bash

# Define the name of the SD card volume as it appears in `diskutil list`
SD_CARD_NAME="LUMIX"

# Path to the Lumix folder on the SD card
LUMIX_FOLDER="/Volumes/$SD_CARD_NAME/DCIM/109_PANA"

# Flag to track if the file has been opened
FILE_OPENED=false

# Infinite loop to continuously check for the SD card
while true; do
  # Use diskutil to list mounted volumes and grep to find the SD card
  if diskutil list | grep -q "$SD_CARD_NAME"; then
    if [ "$FILE_OPENED" = false ]; then
      echo "SD card '$SD_CARD_NAME' detected."

      # Check if the Lumix folder exists
      if [ -d "$LUMIX_FOLDER" ]; then
        echo "Lumix folder found: $LUMIX_FOLDER"

        # Find the latest file in the Lumix folder
        LATEST_FILE=$(find "$LUMIX_FOLDER" -type f -print0 | xargs -0 ls -lt | head -n 1 | awk '{print $9}')

        if [ -n "$LATEST_FILE" ]; then
          echo "Opening the latest file: $LATEST_FILE"
          open "$LATEST_FILE"
          FILE_OPENED=true
        else
          echo "No files found in the Lumix folder."
        fi
      else
        echo "Lumix folder not found: $LUMIX_FOLDER"
      fi
    fi
  else
    # Reset the flag if the SD card is removed
    if [ "$FILE_OPENED" = true ]; then
      echo "SD card '$SD_CARD_NAME' removed."
      FILE_OPENED=false
    fi
  fi

  # Sleep before the next check
  sleep 5
done