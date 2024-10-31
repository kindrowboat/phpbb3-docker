#!/usr/bin/env bash

# Function to prompt for confirmation
confirm() {
    read -p "This will delete 'db' and 'phpbb' directories. Continue? (y/n): " choice
    case "$choice" in
        y|Y ) echo "Proceeding...";;
        n|N ) echo "Operation aborted."; exit 1;;
        * ) echo "Invalid input. Operation aborted."; exit 1;;
    esac
}

# Run the confirmation prompt
confirm

# Remove 'db' and 'phpbb' directories
sudo rm -rf db phpbb
echo "'db' and 'phpbb' directories removed."

# Download the latest phpBB ZIP file
echo "Downloading the latest phpBB..."
curl -L https://download.phpbb.com/pub/release/3.3/3.3.13/phpBB-3.3.13.zip -o phpBB.zip

# Extract phpBB to 'phpbb' directory
echo "Extracting phpBB..."
unzip phpBB.zip -d /tmp/phpbb
mv /tmp/phpbb/phpBB3 phpbb

# Clean up
rm phpBB.zip
echo "phpBB has been downloaded and extracted to the 'phpbb' directory."

