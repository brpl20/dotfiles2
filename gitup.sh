#!/bin/bash

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
    echo "trying Add"
    git add .
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
