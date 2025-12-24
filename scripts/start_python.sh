#!/bin/bash
# =============================================================================
# UHTP Python Viewer Startup Script
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PYTHON_VENV="$HOME/local/venv"

# Check venv exists
if [ ! -d "$PYTHON_VENV" ]; then
    echo "Error: Python venv not found at $PYTHON_VENV"
    echo "Please create the venv:"
    echo "  python3 -m venv $PYTHON_VENV"
    exit 1
fi

# Activate venv
source "$PYTHON_VENV/bin/activate"

# Check python/src exists
if [ ! -d "$PROJECT_ROOT/python/src" ]; then
    echo "Error: python/src not found"
    echo "Please run ./scripts/setup.sh first"
    exit 1
fi

echo "Starting UHTP Python Viewer..."
echo "  Python: $(which python)"
echo "  Venv: $PYTHON_VENV"
echo ""

cd "$PROJECT_ROOT/python"
exec python -m src.main "$@"
