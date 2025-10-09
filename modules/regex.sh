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
API_REGEX="$(dirname "${BASH_SOURCE[0]}")/../regex/api_regex.json"

if [[ $# -eq 0 || "$1" == "--help" ]]; then
  echo -e "${YELLOW}  Usage: ./quevy regex [--module] <target> ${RESET}"
    

  echo -e "${MAGENTA}  [options]${RESET}"
  echo "  --api     check for existed regex in file" 
  echo "  --param   filter url by vuln pattren using url query param"
  echo "            lfi, sqli, xss, redirect, ssrf, ssti, takeover, idor, "

  echo -e "${MAGENTA}  [target]${RESET}"
  echo -e "  -f <file>      Search specific file"
  echo -e "  -d <directory> Search directory recursively"  
  echo -e "  -d .           Current directory"

  exit 0
fi



case "$1" in
    --api)
        shift
        ;;
    --param)
        shift
        ;;
esac



function scanRegex_file () {
    local target_file="$1"
    keys=$(jq -r 'keys[]' "$API_REGEX")
    for key in $keys; do
        regex=$(jq -r --arg k "$key" '.[$k]' "$API_REGEX")
        matches=$(grep -oP "$regex" "$target_file" | sort -u)
        if [[ -n "$matches" ]]; then
            echo -e "Matches for ${RED}[$key]:${RESET}"
            echo "$matches" | sed 's/^/-> /'
        fi
    done
}









    









