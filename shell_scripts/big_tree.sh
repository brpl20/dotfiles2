#!/bin/bash

# Creates a project tree
# and 
# cat all the files 
# use mostly for IA
# Output file in the same directory as this script

script_dir=$(cd "$(dirname "$0")" && pwd)
output_file="$script_dir/project_log.txt"

# Create the output file with a header
echo "Project Tree:" > "$output_file"

# Generate the tree structure while ignoring dot files and libraries
find . -type f -o -type d | grep -v "/\." | grep -v "node_modules" | grep -v "__pycache__" | grep -v "venv" | sort | while read -r item; do
  # Calculate indentation based on directory depth
  depth=$(echo "$item" | tr -cd '/' | wc -c)
  indent=$(printf '%*s' "$depth" '')
  # Get just the basename
  basename=$(basename "$item")
  # Skip dot files
  if [[ ! "$basename" == .* ]]; then
    echo "$indent$basename" >> "$output_file"
  fi
done

# Add a separator
echo -e "\nProject Contents:" >> "$output_file"

# Find all files, sort them, ignore dot files and libraries, and append their contents
find . -type f | grep -v "/\." | grep -v "node_modules" | grep -v "__pycache__" | grep -v "venv" | sort | while read -r file; do
  # Skip the output file itself and dot files
  basename=$(basename "$file")
  if [ "$file" != "$output_file" ] && [[ ! "$basename" == .* ]]; then
    echo -e "\n--- $file ---\n" >> "$output_file"
    cat "$file" >> "$output_file"
    echo -e "\n" >> "$output_file"
  fi
done

echo "Project log has been created as $output_file"