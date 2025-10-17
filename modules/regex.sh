#!/bin/bash
# Show help if no args or --help used
#
# color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m'

#
#
#

getQuery () {
    local file=$1
    cat "$file" | grep "?"

}


API_REGEX="$(dirname "${BASH_SOURCE[0]}")/../regex/api_regex.json"
scanRegex_file () {
    local target_file="$1"
    keys=$(jq -r 'keys[]' "$API_REGEX")
    for key in $keys; do
        regex=$(jq -r --arg k "$key" '.[$k]' "$API_REGEX")
        matches=$(grep -oP "$regex" "$target_file" | sort -u)
        if [[ -n "$matches" ]]; then
            echo -e "Matches for ${RED}[$key]:${RESET}"
            echo "$matches" | sed 's/^/    |-> /'
        fi
    done
}

scanRegex_dir() {
    local target="$1"

    if [[ -d "$target" ]]; then
        for item in "$target"/*; do
            scanRegex_file "$item"
        done
    elif [[ -f "$target" ]]; then
        # If it's a file, process it
        keys=$(jq -r 'keys[]' "$API_REGEX")
        for key in $keys; do
            regex=$(jq -r --arg k "$key" '.[$k]' "$API_REGEX")
            matches=$(grep -oP "$regex" "$target" | sort -u)
            if [[ -n "$matches" ]]; then
                echo -e "Matches for ${RED}[$key]${RESET} in ${CYAN}$target${RESET}:"
                echo "$matches" | sed 's/^/    |-> /'
            fi
        done
    fi
}



if [[ $# -eq 0 || "$1" == "--help" ]]; then
  echo -e "${YELLOW}  Usage: ./quevy regex [--module] <target> ${RESET}"
    

  echo -e "${MAGENTA}  [options]${RESET}"
  echo "  --api     check for existed regex in file" 
  echo "  --param   extract url that contain parameter"

  echo -e "${MAGENTA}  [target]${RESET}"
  echo -e "  -f <file>      Search specific file"
  echo -e "  -d <directory> Search directory recursively"  
  echo -e "  -d .           Current directory"

  exit 0
fi

case "$1" in
    --api)
        echo "You are using API module"
        shift
        case "$1" in
            -f)
                if [ ! -f "$2" ]; then
                    echo "Error: there is no file"
                    exit 1
                fi
                FILE_PATH="$2"
                # /////////////////////////////////// 
                scanRegex_file "$FILE_PATH"
                # /////////////////////////////////// 
                shift 2 
                ;;
            -d)
                if [ ! -d "$2" ]; then
                    echo "Error: there is not directory"
                    exit 1
                fi
                DIRECTORY_PATH="$2"
                # /////////////////////////////////// 
                if [[ "$DIRECTORY_PATH" == "." ]]; then
                    scanRegex_dir "$(pwd)"
                fi
                scanRegex_dir "$DIRECTORY_PATH"                                
                
                # /////////////////////////////////// 
                shift 2
                ;;
            *)
                echo "no target "
                exit 1 
                ;;
        esac
        ;;
    --param)
        echo "You are using PARAM module"
        shift
        case "$1" in
            -f)
                if [ ! -f "$2" ]; then
                    echo "Error: there is no file"
                    exit 1
                fi
                FILE_PATH="$2"
                # /////////////////////////////////// 
                getQuery "$FILE_PATH"                
                # /////////////////////////////////// 
                shift 2 
                ;;
            -d)
                if [ ! -d "$2" ]; then
                    echo "Error: there is no directory"
                    exit 1
                fi
                DIRECTORY_PATH="$2"
                if [ "$DIRECTORY_PATH" ]]; then
                    echo "Hello"
                fi
                # do some shit over here
                shift 2
                ;;
            *)
                echo "no target "
                exit 1 
                ;;
        esac
        ;;
    *)
        echo "No Module with this name"
        exit 1
        ;;
esac












    









