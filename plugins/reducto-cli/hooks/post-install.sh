#!/bin/bash
# Post-install script for reducto-cli plugin
# This script bootstraps reducto-cli using UV

set -e

echo "Installing reducto-cli..."

# Check if uv is available
if ! command -v uv &> /dev/null; then
    echo "UV not found. Installing UV first..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Source the shell profile to get uv in PATH
    export PATH="$HOME/.local/bin:$PATH"
fi

# Pre-cache reducto-cli with uvx so it's ready to use
echo "Pre-caching reducto-cli..."
uv tool install reducto-cli 2>/dev/null || true

echo ""
echo "reducto-cli installed successfully!"
echo ""
echo "To authenticate, run:"
echo "  uvx --from reducto-cli reducto login"
echo ""
echo "Quick start:"
echo "  uvx --from reducto-cli reducto parse document.pdf"
echo "  uvx --from reducto-cli reducto extract invoice.pdf --schema schema.json"
echo "  uvx --from reducto-cli reducto edit form.pdf --instructions 'Fill in name as John'"
