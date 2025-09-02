#!/bin/bash

echo "Waiting for BPSSD drive to mount..."

# Loop until the BPSSD drive is available
while [ ! -d "/Volumes/BPSSD" ]; do
    echo "BPSSD drive not yet available, waiting 10 seconds..."
    sleep 10
done

echo "BPSSD drive detected! Starting brewhd_syncthing.sh"

# Export PATH with HomeBrew location on BPSSD
export PATH="/Volumes/BPSSD/Aplicativos-HomeBrew/bin:$PATH"

# Run the syncthing script
./brewhd_syncthing.sh