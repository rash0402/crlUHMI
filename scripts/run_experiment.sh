#!/bin/bash
# =============================================================================
# UHTP Experiment Runner
# =============================================================================
# Starts both Julia Core and Python Viewer processes
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================="
echo "  UHTP Experiment Runner"
echo "============================================="
echo ""

# Check if processes are already running
if pgrep -f "julia.*UHTP" > /dev/null 2>&1; then
    echo "Warning: Julia UHTP process is already running"
    read -p "Kill existing process? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pkill -f "julia.*UHTP" || true
        sleep 1
    else
        exit 1
    fi
fi

if pgrep -f "python.*src.main" > /dev/null 2>&1; then
    echo "Warning: Python UHTP process is already running"
    read -p "Kill existing process? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pkill -f "python.*src.main" || true
        sleep 1
    fi
fi

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Stopping UHTP processes..."
    pkill -f "julia.*UHTP" 2>/dev/null || true
    pkill -f "python.*src.main" 2>/dev/null || true
    echo "Done."
}
trap cleanup EXIT

# Start Julia Core in background
echo "Starting Julia Core (1kHz control loop)..."
"$SCRIPT_DIR/start_julia.sh" &
JULIA_PID=$!
sleep 2

# Check if Julia started successfully
if ! kill -0 $JULIA_PID 2>/dev/null; then
    echo "Error: Julia Core failed to start"
    exit 1
fi

echo "Julia Core started (PID: $JULIA_PID)"
echo ""

# Start Python Viewer
echo "Starting Python Viewer (60Hz display)..."
"$SCRIPT_DIR/start_python.sh"

# Wait for processes
wait
