#!/bin/bash

# Enable debugging
set -x

# Directory to save the temporary screenshot
TEMP_DIR=$(mktemp -d)
TEMP_FILE="$TEMP_DIR/screenshot.png"

# Take a screenshot using macOS screencapture in interactive mode
screencapture -i $TEMP_FILE

# Check if the screenshot was taken
if [ ! -f $TEMP_FILE ]; then
    echo "Failed to take screenshot."
    exit 1
fi

# Display the screenshot path for verification
echo "Screenshot saved to: $TEMP_FILE"

# Perform OCR using Tesseract in Portuguese
# Redirect stderr to /dev/null to suppress the "Estimating resolution" message
TEXT=$(tesseract $TEMP_FILE stdout -l por 2>/dev/null)

# Check if Tesseract succeeded
if [ $? -ne 0 ]; then
    echo "Tesseract OCR failed."
    exit 1
fi

# Display the extracted text for verification
echo "Extracted text: $TEXT"

# Copy the text to the clipboard using pbcopy
echo -n "$TEXT" | pbcopy

# Verify if the text was added to the clipboard
if [ $? -ne 0 ]; then
    echo "Failed to add text to clipboard."
    exit 1
fi

# Clean up
rm -rf $TEMP_DIR

# Disable debugging
set +x