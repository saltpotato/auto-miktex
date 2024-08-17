#!/bin/bash

# Display usage if the number of arguments is incorrect
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <full_path_to_tex_file> [--it]"
    echo "       --it : Optional flag to start in interactive mode"
    exit 1
fi

# Define the resource folder (adjust the path as necessary)
RESOURCE_DIR="/home/maschu/documents/resources"
# Extract the directory and filename from the provided path
TEX_DIR=$(dirname "$1")
TEX_FILE=$(basename "$1")

# Export the variables for Docker Compose to pick up
export RESOURCE_DIR
export TEX_DIR
export TEX_FILE
export USER_ID=$(id -u)  # Avoid using system reserved variable names

# Check for interactive session flag --it
if [[ " $* " == *" --it "* ]]; then
  export INTERACTIVE_SESSION=true
else
  export INTERACTIVE_SESSION=false
fi

# Navigate to the directory containing your docker-compose.yml
cd $HOME/dev/auto-miktex

# Run Docker Compose
docker-compose up

# Return to the original directory
cd -