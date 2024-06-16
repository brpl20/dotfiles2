#!/bin/bash
cp aliases-base $HOME/.aliases-base
cp aliases-linux $HOME/.aliases-linux
cp aliases-mac $HOME/.aliases-mac
cp zshrc $HOME/.zshrc

# Check the status of the git repository
git status

# Attempt to pull the latest changes from the remote repository
git pull
if [ $? -ne 0 ]; then
    echo "git pull failed. Exiting."
    exit 1
fi

# Add all changes to the staging area
git add .

# Commit the changes with a message
git commit -m "auto-update"
if [ $? -ne 0 ]; then
    echo "git commit failed. Exiting."
    exit 1
fi

# Push the changes to the remote repository
git push origin master
if [ $? -ne 0 ]; then
    echo "git push failed. Exiting."
    exit 1
fi

echo "Changes pulled, committed, and pushed successfully."
