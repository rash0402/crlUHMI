#!/bin/bash
# =============================================================================
# UHTP Julia Core Startup Script
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
JULIA_PATH="$HOME/.juliaup/bin/julia"

# Check Julia exists
if [ ! -f "$JULIA_PATH" ]; then
    echo "Error: Julia not found at $JULIA_PATH"
    echo "Please install Julia via juliaup:"
    echo "  curl -fsSL https://install.julialang.org | sh"
    exit 1
fi

# Check Project.toml exists
if [ ! -f "$PROJECT_ROOT/julia/Project.toml" ]; then
    echo "Error: julia/Project.toml not found"
    echo "Please run ./scripts/setup.sh first"
    exit 1
fi

echo "Starting UHTP Julia Core..."
echo "  Julia: $JULIA_PATH"
echo "  Project: $PROJECT_ROOT/julia"
echo ""

cd "$PROJECT_ROOT/julia"
exec "$JULIA_PATH" --project=. src/UHTP.jl "$@"
