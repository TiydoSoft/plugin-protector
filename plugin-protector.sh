#!/bin/bash

# Function to display help message
show_help() {
    echo "Usage: $(basename "$0") [-p <plugin path>] [-i] [-d] [-h]"
    echo
    echo "Options:"
    echo "  -p <plugin path>  Specify the path to the plugin directory."
    echo "  -i                Create index.php files in all subdirectories (skips existing files)."
    echo "  -d                Add direct access protection to all PHP files."
    echo "  -h                Display this help message."
    echo
    echo "This script allows you to create index.php files and/or add direct access protection"
    echo "to all PHP files within the specified plugin path."
}

# Function to show a loading effect
show_loading() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to create index.php files in all subdirectories
create_index_files() {
    echo "Creating index.php files in all subdirectories..."
    find "$plugin_path" -type d | while read -r dir; do
        if [ ! -f "$dir/index.php" ]; then
            echo "<?php // Silence is golden" > "$dir/index.php"
            echo "[✓] Created $dir/index.php"
        else
            echo "[!] Skipped $dir/index.php (already exists)"
        fi
    done & show_loading
    echo "index.php files created successfully."
}

# Function to add direct access protection to all PHP files
add_direct_access_protection() {
    echo "Adding direct access protection to all PHP files..."
    local protection='if (!defined("ABSPATH")) { exit; } // If this file is called directly, abort.'
    
    find "$plugin_path" -type f -name "*.php" | while read -r file; do
        if ! grep -q "$protection" "$file"; then
            # Check if there is a package comment
            if grep -q "^/\*\*" "$file"; then
                # Add protection after the package comment
                awk -v protection="$protection" '
                BEGIN {added = 0}
                {
                    print $0
                    if (added == 0 && /^ \*\/$/) {
                        print protection
                        added = 1
                    }
                }' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
            else
                # Add protection at the beginning of the file
                echo "$protection" | cat - "$file" > "$file.tmp" && mv "$file.tmp" "$file"
            fi
            echo "[✓] Protected $file"
        else
            echo "[!] Skipped $file (already protected)"
        fi
    done & show_loading
    echo "Direct access protection added successfully."
}

# Parse command-line options
while getopts ":p:idh" opt; do
    case ${opt} in
        p )
            plugin_path=$OPTARG
            ;;
        i )
            create_index=true
            ;;
        d )
            direct_access=true
            ;;
        h )
            show_help
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        : )
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            exit 1
            ;;
    esac
done

# Check if plugin path was provided
if [ -z "$plugin_path" ]; then
    echo "Error: Plugin path not specified."
    show_help
    exit 1
fi

# Check if the path exists
if [ ! -d "$plugin_path" ]; then
    echo "Error: The specified path does not exist."
    exit 1
fi

# Execute the requested operations
if [ "$create_index" = true ]; then
    create_index_files
fi

if [ "$direct_access" = true ]; then
    add_direct_access_protection
fi

# If neither -i nor -d were provided, show an error
if [ -z "$create_index" ] && [ -z "$direct_access" ]; then
    echo "Error: No operation specified. Use -i for index.php or -d for direct access protection."
    show_help
    exit 1
fi
