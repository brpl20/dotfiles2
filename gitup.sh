#!/bin/bash

# Function to display menu and get user choice
select_zshrc_config() {
    echo "Please select your zshrc configuration:"
    echo "1) Full zshrc (complete configuration)"
    echo "2) Minimal zshrc (lightweight configuration)"
    echo "3) Skip zshrc setup"

    while true; do
        read -p "Enter your choice (1-3): " choice
        case $choice in
            1)
                echo "Selected: Full zshrc configuration"
                cp zshrc $HOME/.zshrc
                echo "✓ Copied zshrc to ~/.zshrc"
                break
                ;;
            2)
                echo "Selected: Minimal zshrc configuration"
                cp zshrc-minimal $HOME/.zshrc
                echo "✓ Copied zshrc-minimal to ~/.zshrc"
                break
                ;;
            3)
                echo "Skipping zshrc setup"
                break
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, or 3."
                ;;
        esac
    done
}

# Copy alias files
echo "Setting up alias files..."
cp aliases-base $HOME/.aliases-base
cp aliases-linux $HOME/.aliases-linux
cp aliases-mac $HOME/.aliases-mac
echo "✓ Alias files copied successfully"

# Let user select zshrc configuration
select_zshrc_config

# Note: Fixed typo in original script (zshrc-minimal was being copied to .zhrc instead of .zshrc)

echo ""
echo "Performing git operations..."

# Check the status of the git repository
git status

# Attempt to pull the latest changes from the remote repository
echo "Pulling latest changes..."
git pull
if [ $? -ne 0 ]; then
    echo "❌ git pull failed. Exiting."
    exit 1
fi

# Add all changes to the staging area
echo "Adding changes to staging..."
git add .

# Commit the changes with a message
echo "Committing changes..."
git commit -m "auto-update"
if [ $? -ne 0 ]; then
    echo "❌ git commit failed. Exiting."
    exit 1
fi

# Push the changes to the remote repository
echo "Pushing changes..."
git push origin master
if [ $? -ne 0 ]; then
    echo "❌ git push failed. Exiting."
    exit 1
fi

echo "✅ Changes pulled, committed, and pushed successfully."
echo "Setup completed!"
