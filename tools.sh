#!/bin/bash

# Function to create a simple website
create_website() {
  local content_file="$1"
  local output_dir="$2"

  if [[ ! -f "$content_file" ]]; then
    echo "Error: Content file '$content_file' not found."
    return 1
  fi

  mkdir -p "$output_dir"
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create directory '$output_dir'."
    return 1
  fi

  echo "<!DOCTYPE html>
<html>
<head>
    <title>Simple Website</title>
</head>
<body>
    $(cat "$content_file")
</body>
</html>" > "$output_dir/index.html"

  if [[ $? -eq 0 ]]; then
    echo "Website successfully created in '$output_dir'."
  else
    echo "Error: Failed to create website."
    return 1
  fi
}

# Function to create Nginx configuration
create_nginx_config() {
  local port="$1"
  local root_dir="$2"
  local config_file="/etc/nginx/sites-available/website_$port"

  if [[ -z "$port" || -z "$root_dir" ]]; then
    echo "Error: Port or root directory not provided."
    return 1
  fi

  echo "server {
    listen $port;
    server_name localhost;

    root $root_dir;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}" > "$config_file"

  if [[ $? -eq 0 ]]; then
    ln -sf "$config_file" "/etc/nginx/sites-enabled/"
    echo "Nginx configuration successfully created for port $port."
  else
    echo "Error: Failed to create Nginx configuration."
    return 1
  fi
}
  
