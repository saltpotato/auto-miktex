#!/bin/bash

# Save the original directory
original_dir=$(pwd)

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <tex_file_name>"
    exit 1
fi

# Define the resource folder (adjust the path as necessary)
RESOURCE_DIR="/home/maschu/documents/resources"

# Get the absolute path of the file
file_path=$(realpath "$1")

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File does not exist."
    exit 1
fi

# Extract the directory from the file path and change to it
TEX_DIR=$(dirname "$file_path")
cd "$TEX_DIR"

# if new then log in interactively and run "mpm --update" to update the package database
# Run the Docker container, mounting the resource folder

# Specify the Docker image as a variable
DOCKER_IMAGE="auto-miktex"

# Run the Docker container, mounting the resource folder
# user is 1000
docker run -it \
    -v miktex:/var/lib/miktex \
    -v "$TEX_DIR":/miktex/work \
    -v "$RESOURCE_DIR":/miktex/resources \
    -e MIKTEX_UID=`id -u` \
     "$DOCKER_IMAGE" xelatex \"$(basename "$file_path")\"

# Cleanup: Remove stopped containers
docker_containers=$(docker ps -a -q --filter ancestor="$DOCKER_IMAGE")
if [ -n "$docker_containers" ]; then
        docker rm $docker_containers
fi


# Additional cleanup: Remove auxiliary files
rm -f "$TEX_DIR"/*.log "$TEX_DIR"/*.aux "$TEX_DIR"/*.out

# Return to the original directory
cd "$original_dir"
