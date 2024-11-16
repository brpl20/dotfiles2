#!/bin/bash

# Define the name of the SD card volume as it appears in `diskutil list`
SD_CARD_NAME="LUMIX"

# Path to the file you want to open
FILE_TO_OPEN="/Users/brpl20/Desktop/yourfile.txt"

# Infinite loop to continuously check for the SD card
while true; do
  # Use diskutil to list mounted volumes and grep to find the SD card
  if diskutil list | grep -q "$SD_CARD_NAME"; then
    echo "SD card '$SD_CARD_NAME' detected."

    # Check if the file exists
    if [ -e "$FILE_TO_OPEN" ]; then
      echo "Opening file: $FILE_TO_OPEN"
      open "$FILE_TO_OPEN"
    else
      echo "File not found: $FILE_TO_OPEN"
    fi

    # Sleep for a while to avoid repeated openings
    sleep 10
  else
    echo "SD card '$SD_CARD_NAME' not detected."
  fi

  # Sleep before the next check
  sleep 5
done
