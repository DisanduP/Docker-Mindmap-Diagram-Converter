#!/bin/bash

# Batch Mindmap Converter using Docker
# Usage: ./batch-convert.sh [input_directory] [output_directory] [max_parallel=4]

set -e

INPUT_DIR=${1:-"./input"}
OUTPUT_DIR=${2:-"./output"}
MAX_PARALLEL=${3:-4}

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Starting batch conversion..."
echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Max parallel processes: $MAX_PARALLEL"

# Find all mermaid files
find "$INPUT_DIR" -name "*.mmd" -o -name "*.txt" | while read -r input_file; do
    # Get relative path for output
    relative_path="${input_file#$INPUT_DIR/}"
    output_file="$OUTPUT_DIR/${relative_path%.*}.drawio.xml"

    # Create output subdirectory if needed
    mkdir -p "$(dirname "$output_file")"

    echo "Converting: $input_file -> $output_file"

    # Run conversion in background
    docker run --rm -v "$(pwd)/$INPUT_DIR:/input:ro" -v "$(pwd)/$OUTPUT_DIR:/output" \
        mindmap-converter "/input/$relative_path" "/output/${relative_path%.*}.drawio.xml" &

    # Limit parallel processes
    while [ $(jobs -r | wc -l) -ge $MAX_PARALLEL ]; do
        sleep 0.1
    done
done

# Wait for all background jobs to complete
wait

echo "Batch conversion completed!"
