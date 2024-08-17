#!/bin/bash

# Define the directory to check
DIR="${HOME}"

# Find the largest directories
echo "Finding the largest directories in $DIR..."
du -ah $DIR | sort -rh | head -n 10 > largest_directories.txt

# Find the largest files
echo "Finding the largest files in $DIR..."
find $DIR -type f -exec du -h {} + | sort -rh | head -n 10 > largest_files.txt

# Output results
echo "The 10 largest directories:"
cat largest_directories.txt

echo -e "\nThe 10 largest files:"
cat largest_files.txt
