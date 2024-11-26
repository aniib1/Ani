#!/bin/bash

# Set the output directory
output_dir="/var/www/sites"

count=$1

# Ensure the output directory exists
mkdir -p "$output_dir"

# Generate files with random...
for i in $(seq 1 "$count"); do
    echo "Random content for website $i" > "$output_dir/content_$i.txt"
done

echo "Files with random content created in '$output_dir'."

