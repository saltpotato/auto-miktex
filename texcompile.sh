#!/bin/bash

# Save the original directory
original_dir=$(pwd)

# Set default resource directory
DEFAULT_RESOURCE_DIR="$HOME/documents/resources"

# Initialize variables
INTERACTIVE_MODE="no"
RESOURCE_DIR="$DEFAULT_RESOURCE_DIR"

# Function to display usage information
usage() {
    echo "Usage: $0 <tex_file_name> [options]"
    echo "Options:"
    echo "  -r, --resource-dir <path>   Specify the resource directory"
    echo "  --it                        Run in interactive mode"
    echo "  -h, --help                  Display this help message"
    exit 1
}

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    usage
fi

# Parse command-line arguments
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--resource-dir)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                RESOURCE_DIR="$2"
                shift 2
            else
                echo "Error: --resource-dir requires a non-empty option argument."
                exit 1
            fi
            ;;
        --it)
            INTERACTIVE_MODE="yes"
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*|--*)
            echo "Unknown option: $1"
            usage
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # Save positional arguments
            shift
            ;;
    esac
done

# Restore positional arguments
set -- "${POSITIONAL_ARGS[@]}"

# Get the LaTeX file name from positional arguments
if [ -z "$1" ]; then
    echo "Error: No LaTeX file specified."
    usage
fi

TEX_FILE="$1"

# Get the absolute path of the file
file_path=$(realpath "$TEX_FILE")

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File '$TEX_FILE' does not exist."
    exit 1
fi

# Extract the directory from the file path and change to it
TEX_DIR=$(dirname "$file_path")
cd "$TEX_DIR"

# Specify the Docker image as a variable
DOCKER_IMAGE="auto-miktex"

# Display the resource directory being used
echo "Using resource directory: $RESOURCE_DIR"

# Conditional execution based on interactive mode
if [ "$INTERACTIVE_MODE" == "yes" ]; then
    # Interactive mode: Compile with xelatex then launch a shell
    docker run -it \
        -v miktex:/var/lib/miktex \
        -v "$TEX_DIR":/miktex/work \
        -v "$RESOURCE_DIR":/miktex/resources \
        -e MIKTEX_UID=$(id -u) \
        "$DOCKER_IMAGE" bash -c "xelatex '$(basename "$file_path")'; exec bash"
else
    # Non-interactive mode: Run xelatex
    docker run \
        -v miktex:/var/lib/miktex \
        -v "$TEX_DIR":/miktex/work \
        -v "$RESOURCE_DIR":/miktex/resources \
        -e MIKTEX_UID=$(id -u) \
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