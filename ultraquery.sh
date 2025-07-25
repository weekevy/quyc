#!/bin/bash

URL="$1"
WORDLISTS="$2"
CURRENT_PATH=$(pwd)

if [[ -z "$URL" || -z "$WORDLISTS" ]]; then
    echo "[!] Usage $0 <url> <wordlist>"
    exit 1
fi



function main () {
    python3 "$CURRENT_PATH/modules/scanner.py"
}

main
