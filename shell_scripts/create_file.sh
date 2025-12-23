#!/bin/bash
# This is for context button in file explore not terminal which 
# we can easily do touch

echo "Enter the file name (without extension):"
read filename

echo "Enter the file extension (e.g., txt, md, js, py):"
read extension

touch "$filename.$extension"
echo "File '$filename.$extension' created successfully."
