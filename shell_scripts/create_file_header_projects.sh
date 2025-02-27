#!/bin/bash

# Use current directory as project root
PROJECT_ROOT="$(pwd)"

# Find all files in the project, excluding node_modules, .git, etc. and markdown files
find "$PROJECT_ROOT" -type f \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -not -path "*/build/*" \
  -not -path "*/dist/*" \
  -not -path "*/.next/*" \
  -not -name "*.md" \
  -not -name "*.mdx" \
  | while read file; do
    
    # Get the relative path from the project root
    relative_path=${file#"$PROJECT_ROOT/"}
    
    # Skip files that are not text files
    if file "$file" | grep -q "text"; then
      # Check if the file already has the path comment at the top
      if ! grep -q "^// $relative_path" "$file"; then
        # Create a temporary file
        temp_file=$(mktemp)
        # Add the comment and the original content to the temp file
        echo "// $relative_path" > "$temp_file"
        cat "$file" >> "$temp_file"
        # Replace the original file with the temp file
        mv "$temp_file" "$file"
        echo "Added comment to $file"
      else
        echo "Comment already exists in $file"
      fi
    fi
  done
