#!/bin/bash

# IMF Browser Build Script for WSL (Ubuntu)
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}       IMF Browser WSL Build System       ${NC}"
echo -e "${BLUE}==========================================${NC}"

# 1. Check and install dependencies
echo -e "${BLUE}Checking system dependencies...${NC}"
DEPENDENCIES=(
    "pkg-config"
    "build-essential"
    "curl"
    "wget"
    "libssl-dev"
    "libgtk-3-dev"
    "libwebkit2gtk-4.1-dev"
    "libayatana-appindicator3-dev"
    "librsvg2-dev"
)

MISSING_DEPS=()
for dep in "${DEPENDENCIES[@]}"; do
    if ! dpkg -s "$dep" >/dev/null 2>&1; then
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}Missing dependencies:${NC}"
    for dep in "${MISSING_DEPS[@]}"; do echo "  - $dep"; done
    echo -e "${BLUE}Attempting to install...${NC}"
    sudo apt-get update
    sudo apt-get install -y "${MISSING_DEPS[@]}"
else
    echo -e "${GREEN}All system dependencies are installed.${NC}"
fi

# 2. Project Directory Logic
if [ -d "src-tauri" ]; then
    BASE_DIR="."
else
    BASE_DIR="browser"
fi

# 3. Compilation
echo -e "${BLUE}Compiling IMF Browser for Linux...${NC}"
(cd $BASE_DIR/src-tauri && cargo build --release)

# 4. Binary Handling
BINARY_PATH="$BASE_DIR/src-tauri/target/release/imf-browser"

if [ -f "$BINARY_PATH" ]; then
    echo -e "${GREEN}Success! Binary located at: $BINARY_PATH${NC}"
    if command -v upx &> /dev/null; then
        echo -e "${BLUE}Compressing binary with UPX...${NC}"
        upx --best "$BINARY_PATH"
    else
        echo -e "${RED}UPX not found. Skipping compression. (sudo apt install upx to enable)${NC}"
    fi
else
    echo -e "${RED}Error: Binary not found. Check build logs above.${NC}"
    exit 1
fi

echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}WSL Build Process Completed!${NC}"
echo -e "${BLUE}==========================================${NC}"
