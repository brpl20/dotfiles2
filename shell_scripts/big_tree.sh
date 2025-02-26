#!/bin/bash

# Output file in the current directory where the script is executed
output_file="./project_log.txt"

# Create the output file with a header
echo "Project Tree:" > "$output_file"

# Generate the tree structure while ignoring dot files/folders and libraries
find . -type f -o -type d | grep -v "/\." | grep -v "^\." | grep -v "node_modules" | grep -v "__pycache__" | grep -v "venv" | sort | while read -r item; do
  # Skip if the item itself is a dot file/folder
  if [[ "$(basename "$item")" == .* ]]; then
    continue
  fi
  
  # Calculate indentation based on directory depth
  depth=$(echo "$item" | tr -cd '/' | wc -c)
  indent=$(printf '%*s' "$depth" '')
  # Get just the basename
  basename=$(basename "$item")
  echo "$indent$basename" >> "$output_file"
done

# Add a separator
echo -e "\nProject Contents:" >> "$output_file"

# Find all files, sort them, ignore dot files/folders and libraries, and append their contents
find . -type f | grep -v "/\." | grep -v "^\." | grep -v "node_modules" | grep -v "__pycache__" | grep -v "venv" | sort | while read -r file; do
  # Skip if the file itself is a dot file
  if [[ "$(basename "$file")" == .* ]]; then
    continue
  fi
  
  # Skip the output file itself
  if [ "$file" = "./$output_file" ]; then
    continue
  fi
  
  # Check if file is a text file
  if file "$file" | grep -q "text"; then
    echo -e "\n--- $file ---\n" >> "$output_file"
    cat "$file" >> "$output_file"
    echo -e "\n" >> "$output_file"
  else
    echo -e "\n--- $file --- (binary file, contents not shown)\n" >> "$output_file"
  fi
done

echo "Project log has been created as $output_file in $(pwd)"