#!/bin/bash
# Show help if no args or --help used
#
#
#
#
#
#
API_REGEX="$(dirname "${BASH_SOURCE[0]}")/../regex/api_regex.json"



if [[ $# -eq 0 || "$1" == "--help" ]]; then
  echo "  Usage: ./quevy regex [--module] [-f <file> / -d <directory> /  . <current directory]"
  echo ""
  echo "  --api     scan for existed regex such as google_api, firebase, google_captcha, google_oauth
                    amazon_aws_access_key_id, amazon_mws_auth_toke, amazon_aws_url amazon_aws_url2
                    amazon_aws_url2, facebook_access_token, authorization_basic, authorization_bearer
                    authorization_api, mailgun_api_key, twilio_account_id, twilio_api_key,
                    twilio_app_sid, paypal_braintree_access_token, square_auth_secret, square_access_token
                    stripe_restricted_api, github_access_token, rsa_private_key, ssh_dsa_private_key,
                    ssh_dc_private_key, pgp_private_block, json_web_token, slack_token, SSH_privKey,
                    Heroku_api_key, possible_creds
  " 
  echo "  --vuln    filter url by vuln pattren using url query param"
  echo "            lfi, sqli, xss, redirect, ssrf, ssti, takeover, idor, "
  exit 0
fi
case "$1" in
  --api)
    shift
    while [[ $# -gt 0 ]]; do
      case "$1" in
        -f)
          file_path="$2"  # Get the next argument as file path
          shift 2
          ;;
        -d)
          directory_path="$2"
          shift 2
          ;;
        *)
          echo "Unknown flag : $1" >&2
          exit 1
          ;;
      esac
    done
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

if [[ -f "$file_path" ]]; then
   scanRegex_file "$file_path"
else
    echo "cannot find any file"
fi 









    









