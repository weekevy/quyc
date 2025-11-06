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
get_severity_color() {
    local key=$1
    case "$key" in
        google_api|firebase|amazon_aws_access_key_id|amazon_mws_auth_toke|facebook_access_token|authorization_basic|authorization_bearer|authorization_api|mailgun_api_key|twilio_api_key|twilio_account_sid|twilio_app_sid|paypal_braintree_access_token|square_oauth_secret|square_access_token|stripe_standard_api|stripe_restricted_api|github_access_token|SSH_privKey|Heroku API KEY|possible_Creds)
            echo -e "${RED}"  # High severity
            ;;
        json_web_token|slack_token)
            echo -e "${YELLOW}" # Medium severity
            ;;
        *)
            echo -e "${BLUE}"    # Informational
            ;;
    esac
}

print_match() {
    local key=$1
    local matches=$2
    local file=$3
    local severity_color=$(get_severity_color "$key")

    if [[ -n "$matches" ]]; then
        echo -e "  ${severity_color}[+]${RESET} ${CYAN}Matches for ${severity_color}[$key]${RESET} in ${GREEN}$file${RESET}:"
        echo "$matches" | sed "s/^/    ${severity_color}|->${RESET} /"
    fi
}

scanRegex_file () {
    local target_file="$1"
    local total_matches=0
    local findings=""

    API_REGEX="$(dirname "${BASH_SOURCE[0]}")/../regex/api_regex.json"
    PATHS_REGEX="$(dirname "${BASH_SOURCE[0]}")/../regex/paths_regex.json"

    keys=$(jq -r 'keys[]' "$API_REGEX")
    for key in $keys; do
        regex=$(jq -r --arg k "$key" '.[$k]' "$API_REGEX")
        matches=$(grep -oP "$regex" "$target_file" | sort -u)
        if [[ -n "$matches" ]]; then
            findings+="$(print_match "$key" "$matches" "$target_file")\n"
            total_matches=$((total_matches + $(echo "$matches" | wc -l)))
        fi
    done

    keys=$(jq -r 'keys[]' "$PATHS_REGEX")
    for key in $keys; do
        regex=$(jq -r --arg k "$key" '.[$k]' "$PATHS_REGEX")
        matches=$(grep -oP "$regex" "$target_file" | sort -u)
        if [[ -n "$matches" ]]; then
            findings+="$(print_match "$key" "$matches" "$target_file")\n"
            total_matches=$((total_matches + $(echo "$matches" | wc -l)))
        fi
    done

    if [[ $total_matches -gt 0 ]]; then
        echo -e "${BLUE}[*]${RESET} Scanning file: ${GREEN}$target_file${RESET}"
        echo -e "$findings"
        echo -e "${BLUE}[*]${RESET} Scan complete for file: ${GREEN}$target_file${RESET}"
        echo -e "${BLUE}[*]${RESET} Total matches found: ${RED}$total_matches${RESET}"
    fi
}

scanRegex_dir() {
    local target="$1"
    local total_files=0

    if [[ -d "$target" ]]; then
        echo -e "${BLUE}[*]${RESET} Scanning directory: ${GREEN}$target${RESET}"
        for item in "$target"/*; do
            if [[ -f "$item" ]]; then
                scanRegex_file "$item"
                total_files=$((total_files + 1))
            fi
        done
        echo -e "${BLUE}[*]${RESET} Scan complete for directory: ${GREEN}$target${RESET}"
        echo -e "${BLUE}[*]${RESET} Total files scanned: ${RED}$total_files${RESET}"
    elif [[ -f "$target" ]]; then
        scanRegex_file "$target"
    fi
}






if [[ $# -eq 0 || "$1" == "--help" ]]; then
  echo -e "${YELLOW}  Usage: ./quevy regex [--module] <target> ${RESET}"
    

  echo -e "${MAGENTA}  [options]${RESET}"
  echo "  --secrets     check for existed regex in file" 
  echo "  --juicy       Can contain juicy information"

  echo -e "${MAGENTA}  [target]${RESET}"
  echo -e "  -url <url>        JavaScript endpoint extract"
  echo -e "  -f   <file>       Search specific file"
  echo -e "  -d   <directory>  Search directory recursively"  
  echo -e "  -d .              Current directory"

  exit 0
fi


case "$1" in
    --secrets)
        echo "You are using [js] module"
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
            
            -url)
                URL=$2
                if [[ $URL =~ ^https?://.*\.js$ ]]; then
                # /////////////////////////////////// 
                 
                # /////////////////////////////////// 
                else
                    echo "Wrong url form !"
                fi
                shift 2
                ;;
            *)
                echo "no target "
                exit 1 
                ;;
        esac
        ;;
    --juicy)
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












    









