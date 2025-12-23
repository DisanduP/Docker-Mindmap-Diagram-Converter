#!/bin/bash

# Parallel Mindmap Converter using Docker and xargs
# Usage: ./parallel-convert.sh [input_directory] [output_directory] [max_parallel=4]

set -e

INPUT_DIR=${1:-"./input"}
OUTPUT_DIR=${2:-"./output"}
MAX_PARALLEL=${3:-4}

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Starting parallel conversion..."
echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Max parallel processes: $MAX_PARALLEL"

# Function to convert a single file
convert_file() {
    abs_input_file="$1"
    input_dir="$2"
    output_dir="$3"

    # Get absolute paths
    abs_input_dir="$(cd "$input_dir" && pwd)"
    abs_output_dir="$(cd "$output_dir" && pwd)"

    # Get relative path from input directory
    relative_path="${abs_input_file#$abs_input_dir/}"
    abs_output_file="$abs_output_dir/${relative_path%.*}.drawio.xml"

    # Create output subdirectory if needed
    mkdir -p "$(dirname "$abs_output_file")"

    echo "Converting: $abs_input_file -> $abs_output_file"

    # Run Docker conversion
    docker run --rm -v "$abs_input_dir:/input:ro" -v "$abs_output_dir:/output" \
        mindmap-converter "/input/$relative_path" "/output/${relative_path%.*}.drawio.xml"

    echo "Completed: $abs_output_file"
}

export -f convert_file

# Find all mermaid files and process them in parallel
find "$(cd "$INPUT_DIR" && pwd)" \( -name "*.mmd" -o -name "*.txt" \) -print0 | while IFS= read -r -d '' file; do
    convert_file "$file" "$INPUT_DIR" "$OUTPUT_DIR" &

    # Limit parallel processes
    running_jobs=$(jobs -r | wc -l)
    while [ "$running_jobs" -ge "$MAX_PARALLEL" ]; do
        sleep 0.1
        running_jobs=$(jobs -r | wc -l)
    done
done

# Wait for all background jobs to complete
wait

echo "Parallel conversion completed!"
