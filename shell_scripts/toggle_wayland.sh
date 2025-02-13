#!/bin/bash

# Define the file path
FILE="/etc/gdm3/daemon.conf"

# Check if the file exists
if [[ ! -f "$FILE" ]]; then
  echo "Error: File $FILE does not exist."
  exit 1
fi

# Toggle the WaylandEnable line
if grep -q "^WaylandEnable=false" "$FILE"; then
  # If the line is uncommented, comment it
  sed -i 's/^WaylandEnable=false/#WaylandEnable=false/' "$FILE"
  echo "WaylandEnable=false has been commented."
else
  # If the line is commented, uncomment it
  sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' "$FILE"
  echo "WaylandEnable=false has been uncommented."
fi

# Force a reboot
echo "Rebooting the system..."
reboot
