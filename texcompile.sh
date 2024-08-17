#!/bin/bash

# Save the original directory
original_dir=$(pwd)

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <tex_file_name> [--it]"
    exit 1
fi

# Define the resource folder (adjust the path as necessary)
RESOURCE_DIR="/home/maschu/documents/resources"

# Check for interactive flag
INTERACTIVE_MODE="no"
for arg in "$@"; do
  if [[ "$arg" == "--it" ]]; then
    INTERACTIVE_MODE="yes"
  fi
done

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

# Specify the Docker image as a variable
DOCKER_IMAGE="auto-miktex"

# Conditional execution based on interactive mode
if [ "$INTERACTIVE_MODE" == "yes" ]; then
    # Interactive mode: Launch a shell
    docker run -it \
        -v miktex:/var/lib/miktex \
        -v "$TEX_DIR":/miktex/work \
        -v "$RESOURCE_DIR":/miktex/resources \
        -e MIKTEX_UID=`id -u` \
        "$DOCKER_IMAGE" /bin/bash
else
    # Non-interactive mode: Run xelatex
    docker run -it \
        -v miktex:/var/lib/miktex \
        -v "$TEX_DIR":/miktex/work \
        -v "$RESOURCE_DIR":/miktex/resources \
        -e MIKTEX_UID=`id -u` \
        "$DOCKER_IMAGE" xelatex "$(basename "$file_path")"
fi

# Cleanup: Remove stopped containers
docker_containers=$(docker ps -a -q --filter ancestor="$DOCKER_IMAGE")
if [ -n "$docker_containers" ]; then
    docker rm $docker_containers
fi

# Additional cleanup: Remove auxiliary files
rm -f "$TEX_DIR"/*.log "$TEX_DIR"/*.aux "$TEX_DIR"/*.out

# Return to the original directory
cd "$original_dir"