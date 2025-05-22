#!/bin/bash

# Universal PDF Compression System with File Splitting
# Usage: ./compress_pdf.sh document.pdf [-c max_size_mb]
# Example: ./compress_pdf.sh document.pdf -c 4

INPUT_PDF="$1"
MAX_SIZE_MB=0

# Parse arguments
if [[ "$2" == "-c" && -n "$3" ]]; then
    MAX_SIZE_MB="$3"
fi

# Get base filename without extension
BASE_NAME=$(basename "$INPUT_PDF" .pdf)

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    INSTALL_CMD="brew install"
else
    OS="linux" 
    INSTALL_CMD="sudo apt install"
fi

# Check for required tools
check_tool() {
    local tool=$1
    local package=$2
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Error: $tool required. Install with: $INSTALL_CMD $package"
        exit 1
    fi
}

check_tool "gs" "ghostscript"
check_tool "qpdf" "qpdf"
check_tool "pdfinfo" "$([ "$OS" = "mac" ] && echo "poppler" || echo "poppler-utils")"

# Create temp directory
if [ "$OS" = "mac" ]; then
    TEMP_DIR=$(mktemp -d -t pdf_compress)
else
    TEMP_DIR=$(mktemp -d)
fi
trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to get file size in MB
get_file_size_mb() {
    local file="$1"
    if [ "$OS" = "mac" ]; then
        stat -f%z "$file" | awk '{print int($1/1024/1024) + 1}'
    else
        stat --printf="%s" "$file" | awk '{print int($1/1024/1024) + 1}'
    fi
}

# Function to get human readable file size
get_file_size_human() {
    local file="$1"
    if [ "$OS" = "mac" ]; then
        du -h "$file" | awk '{print $1}'
    else
        du -h "$file" | cut -f1
    fi
}

# Function to get total pages
get_page_count() {
    pdfinfo "$1" | grep "Pages:" | awk '{print $2}'
}

# Function to split PDF into page ranges
split_pdf_by_pages() {
    local input_pdf="$1"
    local start_page="$2"
    local end_page="$3"
    local output_file="$4"
    
    qpdf --pages "$input_pdf" "$start_page-$end_page" -- --empty "$output_file"
}

# Function to compress a single PDF
compress_single_pdf() {
    local input="$1"
    local output="$2"
    
    # Step 1: Apply MRC-like compression with Ghostscript
    gs -sDEVICE=pdfwrite \
       -dPDFSETTINGS=/ebook \
       -dCompatibilityLevel=1.4 \
       -dNOPAUSE \
       -dQUIET \
       -dBATCH \
       -dColorConversionStrategy=/Gray \
       -dDownsampleColorImages=true \
       -dColorImageResolution=150 \
       -dDownsampleGrayImages=true \
       -dGrayImageResolution=150 \
       -dDownsampleMonoImages=true \
       -dMonoImageResolution=150 \
       -dJPEGQ=30 \
       -dDetectDuplicateImages=true \
       -dCompressFonts=true \
       -dEmbedAllFonts=false \
       -sOutputFile="$TEMP_DIR/stage1.pdf" \
       "$input"

    # Step 2: Strip metadata and optimize structure with qpdf
    qpdf --linearize \
         --object-streams=generate \
         --compress-streams=y \
         --recompress-flate \
         --remove-page-labels \
         "$TEMP_DIR/stage1.pdf" \
         "$TEMP_DIR/stage2.pdf"

    # Step 3: Flatten any form fields and remove annotations
    gs -sDEVICE=pdfwrite \
       -dNOPAUSE \
       -dQUIET \
       -dBATCH \
       -dPrinted=false \
       -sOutputFile="$output" \
       "$TEMP_DIR/stage2.pdf"
}

echo "Processing $INPUT_PDF on $OS system..."

# Get total pages
TOTAL_PAGES=$(get_page_count "$INPUT_PDF")
echo "Total pages: $TOTAL_PAGES"

# If no size limit, compress normally
if [ "$MAX_SIZE_MB" -eq 0 ]; then
    compress_single_pdf "$INPUT_PDF" "${BASE_NAME}_compressed.pdf"
    
    ORIGINAL_SIZE=$(get_file_size_human "$INPUT_PDF")
    COMPRESSED_SIZE=$(get_file_size_human "${BASE_NAME}_compressed.pdf")
    
    echo "Compression complete:"
    echo "Original size: $ORIGINAL_SIZE"
    echo "Compressed size: $COMPRESSED_SIZE"
    echo "Output saved to ${BASE_NAME}_compressed.pdf"
else
    echo "Splitting into chunks of max ${MAX_SIZE_MB}MB each..."
    
    # First pass: determine how many files we'll need
    TEMP_FILES=()
    CURRENT_PAGE=1
    PART_NUM=1
    
    # Create all the chunks first
    while [ $CURRENT_PAGE -le $TOTAL_PAGES ]; do
        # Binary search for maximum pages that fit in size limit
        LOW_PAGE=$CURRENT_PAGE
        HIGH_PAGE=$TOTAL_PAGES
        BEST_END_PAGE=$CURRENT_PAGE
        
        while [ $LOW_PAGE -le $HIGH_PAGE ]; do
            MID_PAGE=$(((LOW_PAGE + HIGH_PAGE) / 2))
            
            # Create test chunk
            TEST_FILE="$TEMP_DIR/test_chunk.pdf"
            split_pdf_by_pages "$INPUT_PDF" "$CURRENT_PAGE" "$MID_PAGE" "$TEST_FILE"
            compress_single_pdf "$TEST_FILE" "$TEMP_DIR/test_compressed.pdf"
            
            TEST_SIZE=$(get_file_size_mb "$TEMP_DIR/test_compressed.pdf")
            
            if [ "$TEST_SIZE" -le "$MAX_SIZE_MB" ]; then
                BEST_END_PAGE=$MID_PAGE
                LOW_PAGE=$((MID_PAGE + 1))
            else
                HIGH_PAGE=$((MID_PAGE - 1))
            fi
        done
        
        # Store the page range for this chunk
        TEMP_FILES+=("$CURRENT_PAGE:$BEST_END_PAGE")
        CURRENT_PAGE=$((BEST_END_PAGE + 1))
        PART_NUM=$((PART_NUM + 1))
    done
    
    TOTAL_FILES=$((PART_NUM - 1))
    echo "Will create $TOTAL_FILES files"
    
    # Second pass: create the final files with proper naming
    PART_NUM=1
    for range in "${TEMP_FILES[@]}"; do
        START_PAGE=${range%:*}
        END_PAGE=${range#*:}
        
        # Create chunk
        CHUNK_FILE="$TEMP_DIR/chunk_${PART_NUM}.pdf"
        OUTPUT_FILE="${BASE_NAME}_compressed_${PART_NUM}_de_${TOTAL_FILES}.pdf"
        
        split_pdf_by_pages "$INPUT_PDF" "$START_PAGE" "$END_PAGE" "$CHUNK_FILE"
        compress_single_pdf "$CHUNK_FILE" "$OUTPUT_FILE"
        
        CHUNK_SIZE=$(get_file_size_human "$OUTPUT_FILE")
        echo "Created: $OUTPUT_FILE (pages $START_PAGE-$END_PAGE, $CHUNK_SIZE)"
        
        PART_NUM=$((PART_NUM + 1))
    done
    
    echo "Split into $TOTAL_FILES files, each under ${MAX_SIZE_MB}MB"
fi

echo "Processing complete!"