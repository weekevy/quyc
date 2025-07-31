#!/bin/bash
if [[ -n "$1" && "$1" != -* ]]; then
    EXTENSIONS=$(echo "$1" | sed 's/,/|/g')
    shift
else
    EXTENSIONS="php|asp|aspx|jsp|json|js|html|htm|py|rb|pl|go|sh|cgi"
fi
isPipe() {
    [ ! -t 0 ]
}
if isPipe; then
    INPUT_DATA=$(cat)
elif [[ -n "$1" ]]; then
    if [[ -f "$1" ]]; then
        INPUT_DATA=$(cat "$1")
    else
        echo "Error: File '$1' not found." >&2
        exit 1
    fi
else
    echo "Usage: ultraquery endp [extensions] [file]" >&2
    echo "Example:" >&2
    echo "  cat urls.txt | ultraquery endp php,js" >&2
    echo "  ultraquery endp php,js urls.txt" >&2
    exit 1
fi
echo "$INPUT_DATA" | grep -Ei "\.($EXTENSIONS)" | sort -u

