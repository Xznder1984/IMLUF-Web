#!/bin/bash

# IMF Browser Build Script
# Supports: Linux, Windows, macOS (Local build focus)

set -e

# Determine the base directory of the project
# If the script is run from within the 'browser' directory, use current dir.
# Otherwise, assume it's run from the root and look for 'browser' folder.
if [ -d "src-tauri" ]; then
    BASE_DIR="."
else
    BASE_DIR="browser"
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}       IMF Browser Build System           ${NC}"
echo -e "${BLUE}==========================================${NC}"

# Function to print usage
usage() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  --all        Build for current OS and attempt to set up other targets"
    echo "  --linux      Build for Linux (current OS must be Linux/WSL)"
    echo "  --windows    Build for Windows (current OS must be Windows)"
    echo "  --macos      Build for macOS (current OS must be macOS)"
    echo "  --clean      Clean build artifacts before compiling"
    echo "  --help       Show this help message"
    exit 1
}

# Check if any arguments were provided
if [ $# -eq 0 ]; then
    usage
fi

CLEAN=false
TARGET="current"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --clean) CLEAN=true ;;
        --linux) TARGET="x86_64-unknown-linux-gnu" ;;
        --windows) TARGET="x86_64-pc-windows-msvc" ;;
        --macos) TARGET="x86_64-apple-darwin" ;;
        --all) TARGET="all" ;;
        --help) usage ;;
        *) echo -e "${RED}Unknown option: $1${NC}"; usage ;;
    esac
    shift
done

# Cleaning
if [ "$CLEAN" = true ]; then
    echo -e "${BLUE}Cleaning build artifacts...${NC}"
    (cd $BASE_DIR/src-tauri && cargo clean)
fi

# Build function
do_build() {
    local target_name=$1
    local display_name=$2
    
    echo -e "${GREEN}Building for $display_name...${NC}"
    
    if [ "$target_name" == "current" ]; then
        (cd $BASE_DIR/src-tauri && cargo build --release)
    else
        echo -e "${BLUE}Adding rust target $target_name...${NC}"
        rustup target add "$target_name"
        (cd $BASE_DIR/src-tauri && cargo build --release --target "$target_name")
    fi

    # Find the binary
    local binary_path=""
    if [ "$target_name" == "current" ]; then
        # Detect OS for binary extension
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
            binary_path="$BASE_DIR/src-tauri/target/release/imf-browser.exe"
        else
            binary_path="$BASE_DIR/src-tauri/target/release/imf-browser"
        fi
    else
        binary_path="$BASE_DIR/src-tauri/target/$target_name/release/imf-browser"
        [[ "$target_name" == *"windows"* ]] && binary_path+=".exe"
    fi

    if [ -f "$binary_path" ]; then
        echo -e "${GREEN}Success! Binary located at: $binary_path${NC}"
        
        # Try to compress with UPX if available
        if command -v upx &> /dev/null; then
            echo -e "${BLUE}Compressing binary with UPX...${NC}"
            upx --best "$binary_path"
        else
            echo -e "${RED}UPX not found. Skipping compression.${NC}"
        fi
    else
        echo -e "${RED}Error: Binary not found at $binary_path${NC}"
        echo -e "${RED}Note: Cross-compiling Tauri requires system-level webview libraries for the target OS.${NC}"
    fi
}

# Main Execution Logic
if [ "$TARGET" == "all" ]; then
    do_build "current" "Current OS"
    do_build "x86_64-unknown-linux-gnu" "Linux"
    do_build "x86_64-pc-windows-msvc" "Windows"
    do_build "x86_64-apple-darwin" "macOS"
elif [ "$TARGET" == "current" ]; then
    do_build "current" "Current OS"
else
    case $TARGET in
        "x86_64-unknown-linux-gnu") do_build "$TARGET" "Linux" ;;
        "x86_64-pc-windows-msvc") do_build "$TARGET" "Windows" ;;
        "x86_64-apple-darwin") do_build "$TARGET" "macOS" ;;
    esac
fi

echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}Build Process Completed!${NC}"
echo -e "${BLUE}==========================================${NC}"
