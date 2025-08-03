#!/bin/bash

# gex module - extracting tool for finding file extensions
# Usage: gex -f <file> -e <extension>
# Parse command line options
while getopts "f:e:" opt; do
    case $opt in
        f) file="$OPTARG" ;;
        e) ext="$OPTARG" ;;
        *) 
            echo -e "${RED}Usage: gex -f <file> -e <extension>${RESET}" >&2
            echo "  -f <file>      File to search in"
            echo "  -e <extension> Extension to search for"
            exit 1 
            ;;
    esac
done

# Check if required parameters are provided
if [ -z "$file" ] || [ -z "$ext" ]; then
    echo -e "${RED}Error: Both file and extension parameters are required${RESET}" >&2
    echo -e "${YELLOW}Usage: gex -f <file> -e <extension>${RESET}" >&2
    exit 1
fi

# Check if file exists and is readable
if [ ! -f "$file" ]; then
    echo -e "${RED}Error: File '$file' does not exist or is not readable${RESET}" >&2
    exit 1
fi

# Search for the extension pattern in the file
echo -e "${GREEN}Searching for '.${ext}' extensions in ${file}...${RESET}"
echo ""

# Using more robust regex pattern matching
if grep -n "\\.${ext}\\b" "$file"; then
    echo ""
    echo -e "${GREEN}Search completed successfully${RESET}"
else
    echo -e "${YELLOW}No matches found for '.${ext}' extension${RESET}"
fi
