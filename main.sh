#!/bin/bash

# run script as root
if [[ $EUID -ne 0 ]]; then
  echo "Please run the script as root."
  exit 1
fi

# Source the helper functions from tools.sh
source ./tools.sh

# Installing Nginx
install_nginx() {
  apt update && apt install -y nginx
  if [[ $? -eq 0 ]]; then
    echo "Nginx installed"
  else
    echo "Error - Failed to install Nginx."
    exit 1
  fi
}

# Function to generate random content files
generate_random_content() {
  local count="$1"
  local output_dir="./content_files"

  mkdir -p "$output_dir"
  for i in $(seq 1 "$count"); do
    echo "Random content for website $i" > "$output_dir/content_$i.txt"
  done
  echo "Random content files created in '$output_dir'."
}

# Main function
main() {
  local website_count="$1"
  local base_port=8000
  local websites_root="/var/www/websites"

  if [[ -z "$website_count" || "$website_count" -le 0 ]]; then
    echo "Error - Please specify a valid number of websites."
    exit 1
  fi

  install_nginx
  generate_random_content "$website_count"

  for i in $(seq 1 "$website_count"); do
    local port=$((base_port + i - 1))
    local content_file="./content_files/content_$i.txt"
    local site_dir="$websites_root/website_$i"

    create_website "$content_file" "$site_dir"
    if [[ $? -ne 0 ]]; then
      echo "Error - creating $i. skipping..."
      continue
    fi

    create_nginx_config "$port" "$site_dir"
    if [[ $? -ne 0 ]]; then
      echo "Error - configuring Nginx for web $i. skipping..."
      continue
    fi
  done

  systemctl restart nginx
  if [[ $? -eq 0 ]]; then
    echo "Nginx successfully restarted."
  else
    echo "Error - Failed to restart Nginx."
    exit 1
  fi
}

main "$1"
