#!/bin/bash

# Directory for websites
base_dir="/var/www"
output_dir="$base_dir/sites"

# Number of websites to generate (passed as an argument)
count=$1

# Ensure base directory exists
sudo mkdir -p "$output_dir"

# Loop to generate websites and configure Nginx
for i in $(seq 1 "$count"); do
    # Define port and directories
    port=$((8000 + i)) # Port starts from 8001
    site_dir="$output_dir/site_$i"
    conf_file="/etc/nginx/sites-available/site_$i"

    # Create website directory and index.html
    sudo mkdir -p "$site_dir"
    echo "<h1>Welcome to Website $i on Port $port</h1>" | sudo tee "$site_dir/index.html"

    # Generate Nginx configuration for the site
    sudo bash -c "cat > $conf_file" <<EOL
server {
    listen $port;
    server_name localhost;

    root $site_dir;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

    # Enable site by linking it to sites-enabled
    sudo ln -sf "$conf_file" /etc/nginx/sites-enabled/

    echo "Configured site $i on port $port with root $site_dir"
done

# Test Nginx configuration and reload
sudo nginx -t && sudo systemctl reload nginx

echo "All $count websites have been configured and started."

