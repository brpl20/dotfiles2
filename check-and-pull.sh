#!/bin/bash

# Path to your code folder
CODE_DIR="/home/brpl/code"

# Initialize an array to store directories with uncommitted changes
repos_with_changes=()

# Iterate through each directory in the code folder
for dir in "$CODE_DIR"/*/; do
    # Check if it's a Git repository
    if [ -d "$dir/.git" ]; then
        echo "Checking repository in $dir"
        
        # Change to the directory
        cd "$dir" || continue

        # Check for local changes
        if [ -n "$(git status --porcelain)" ]; then
            echo "Uncommitted changes found in $dir"
            repos_with_changes+=("$dir")
        else
            echo "No uncommitted changes in $dir"
        fi

        # Pull the latest changes
        echo "Pulling latest changes..."
        git pull

        echo "-----------------------------"
    fi
done

# Final report
if [ ${#repos_with_changes[@]} -ne 0 ]; then
    echo "Please check these repositories with uncommitted changes:"
    for repo in "${repos_with_changes[@]}"; do
        echo "$repo"
    done
else
    echo "All repositories are clean."
fi