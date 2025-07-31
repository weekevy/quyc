
#!/bin/bash
TOOL=$1
shift
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL_PATH="$SCRIPT_DIR/modules/${TOOL}.sh"
if [[ -z "$TOOL" || "$TOOL" == "--help" ]]; then
    echo "Usage: ultraquery <module> [options]"
    echo ""
    echo "Available modules:"
    for file in "$SCRIPT_DIR/modules/"*.sh; do
        echo "  $(basename "$file" .sh)"
    done
    exit 0
fi

if [[ ! -f "$TOOL_PATH" ]]; then
    echo "[!] Unknown module: $TOOL"
    echo "Run: ultraquery --help"
    exit 1
fi
bash "$TOOL_PATH" "$@"

