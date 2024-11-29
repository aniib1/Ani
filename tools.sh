#!/bin/bash

# Check and install Nginx if not installed
install_nginx() {
    if ! command -v nginx &> /dev/null; then
        echo "Nginx is not installed. Installing..."
        sudo apt update && sudo apt install nginx -y
    else
        echo "Nginx is already installed."
    fi
}

# Function to generate random content
generate_random_content() {
    local file_path="$1"
    echo "Generating random content in $file_path..."
    echo "Random content $RANDOM" > "$file_path"
}

# Function to generate files
generate_files() {
    local base_dir="${1:-/var/www}"
    local num_files="${2:-5}"
    mkdir -p "$base_dir"
    
    echo "Generating $num_files files in $base_dir..."
    for ((i=1; i<=num_files; i++)); do
        local file_path="$base_dir/file_$i.txt"
        generate_random_content "$file_path"
    done
    echo "Files successfully created."
}

# Function to setup websites
setup_websites() {
    local base_dir="${1:-/var/www}"
    local num_sites="${2:-3}"
    install_nginx
    
    echo "Setting up $num_sites websites in $base_dir..."
    for ((i=1; i<=num_sites; i++)); do
        local site_dir="$base_dir/site_$i"
        mkdir -p "$site_dir"
        echo "<html><body><h1>Site $i</h1></body></html>" > "$site_dir/index.html"
    done
    echo "Websites successfully set up."
}
  
