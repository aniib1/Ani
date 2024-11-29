#!/bin/bash

# Source tools.sh
source ./tools.sh

# Global variable
main="${1:-/var/www}"

# Setup websites
setup_websites "$main" 3

# Generate files
generate_files "$main" 10

