#!/bin/bash

# Define the directory where the scripts will be created
SCRIPT_DIR="/Users/brpl20/code/dotfiles2/scripts"
mkdir -p "$SCRIPT_DIR"

# Create the script for Profile 1
cat <<EOL > "$SCRIPT_DIR/open_chrome_profile_1.sh"
#!/bin/bash
open -na "Google Chrome" --args --profile-directory="Profile 1"
EOL

# Create the script for Profile 3
cat <<EOL > "$SCRIPT_DIR/open_chrome_profile_3.sh"
#!/bin/bash
open -na "Google Chrome" --args --profile-directory="Profile 3"
EOL

# Create the script for Profile 6
cat <<EOL > "$SCRIPT_DIR/open_chrome_profile_6.sh"
#!/bin/bash
open -na "Google Chrome" --args --profile-directory="Profile 6"
EOL

# Make the scripts executable
chmod +x "$SCRIPT_DIR/open_chrome_profile_1.sh"
chmod +x "$SCRIPT_DIR/open_chrome_profile_3.sh"
chmod +x "$SCRIPT_DIR/open_chrome_profile_6.sh"

echo "Scripts created and made executable in $SCRIPT_DIR"
