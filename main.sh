#!/bin/bash

# Source tools.sh
source ./tools.sh

# Global variable
website_count="${1:-1}"
base_dir="${2:-/var/www}"

#Check and install nginx if not present
install_nginx

# generate websire directories and files
generate_website_files $website_count $base_dir

# Generate nginx config files
generate_nginx_config_files $website_count $base_dir

#Retsarting nginx to load new configs
systemctl  restart nginx

