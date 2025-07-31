
#!/bin/bash

FILE=""
TYPE=""

function usage() {

    echo "Usage: ultraquery regex [-f <file>] -t <type>"
    echo ""
    echo "You can provide input via -f <file> or pipe data into the command."
    echo ""
    echo "Types:"
    echo "  php       Extract .php endpoints"
    echo "  js        Extract .js endpoints"
    echo "  url       Extract full URLs"
    echo "  param     Extract GET parameter parts"
    echo "  bak       Extract backup files (.bak)"
    echo "  env       Extract environment files (.env)"
    echo "  aspx      Extract .aspx endpoints"
    echo "  jsp       Extract .jsp endpoints"
    echo "  json      Extract .json files/endpoints"
    exit 1


}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        -t|--type)
            TYPE="$2"
            shift 2
            ;;
        *)
            echo "[!] Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$TYPE" ]]; then
    echo "[!] Missing required -t (type)"
    usage
fi

case $TYPE in
    php)
        REGEX='\.php'
        ;;
    js)
        REGEX='\.js'
        ;;
    url)
        REGEX='https?://'
        ;;
    param)
        REGEX='[?&][a-zA-Z0-9_]\+='
        ;;
    bak)
        REGEX='\.bak\b'
        ;;
    env)
        REGEX='\.env\b'
        ;;
    aspx)
        REGEX='\.aspx'
        ;;
    jsp)
        REGEX='\.jsp'
        ;;
    json)
        REGEX='\.json'
        ;;
    *)
        echo "[!] Unsupported type: $TYPE"
        usage
        ;;
esac

echo "[*] Grepping '$TYPE' matches"

if [[ -n "$FILE" ]]; then
    grep -E "$REGEX" "$FILE"
else
    grep -E "$REGEX"
fi

