#!/bin/bash

# Kill QuickTime Player
echo "Killing QuickTime Player..."
pkill "QuickTime Player"

# Unmount the SD card
echo "Unmounting SD card..."
diskutil unmount /Volumes/LUMIX

if [ $? -eq 0 ]; then
  echo "SD card successfully unmounted."
else
  echo "Failed to unmount SD card. Please check if it is in use."
fi