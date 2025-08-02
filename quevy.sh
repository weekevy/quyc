#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'
# 
MODULE="$1"
shift
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_PATH="$SCRIPT_DIR/modules/${MODULE}.sh"


function banner () {
    echo "  Weekeyv@ v0.1"
}


function main () {
    banner
    if [[ -f "$MODULE_PATH" ]]; then
        bash "$MODULE_PATH" "$@"
    else
        echo -e " ${RED} Modules${RESET}"
        echo ""
        echo "  gex    extracting tool"
        exit 1
    fi

}
main





