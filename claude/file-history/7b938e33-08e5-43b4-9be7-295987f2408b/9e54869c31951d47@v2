#!/usr/bin/env bash
#
# Restow Script
#
# Unstows and restows all packages
# Useful after adding new files or restructuring
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔══════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Restowing Dotfiles         ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════╝${NC}"
echo ""

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}✗ GNU Stow is not installed${NC}"
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1

# Available packages
PACKAGES=(
    "zsh"
    "hypr"
    "walker"
    "waybar"
    "nvim"
    "alacritty"
    "ghostty"
    "tmux"
    "starship"
    "ohmyposh"
    "claude"
    "scripts"
)

# If arguments provided, only restow those packages
if [ $# -gt 0 ]; then
    PACKAGES=("$@")
    echo -e "${CYAN}Restowing specific packages:${NC} ${PACKAGES[*]}"
else
    echo -e "${CYAN}Restowing all packages${NC}"
fi

echo ""

SUCCESS=0
FAILED=0

for package in "${PACKAGES[@]}"; do
    if [ ! -d "$package" ]; then
        echo -e "  ${RED}✗${NC} ${CYAN}$package${NC} - directory not found"
        FAILED=$((FAILED + 1))
        continue
    fi

    echo -e "  ${YELLOW}↻${NC} Restowing ${CYAN}$package${NC}..."

    if stow --restow "$package" 2>&1 | grep -qi "error"; then
        echo -e "  ${RED}✗${NC} Failed: ${CYAN}$package${NC}"
        FAILED=$((FAILED + 1))
    else
        echo -e "  ${GREEN}✓${NC} ${CYAN}$package${NC}"
        SUCCESS=$((SUCCESS + 1))
    fi
done

echo ""
echo -e "${BLUE}════════════════════════════════════${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Successfully restowed $SUCCESS package(s)${NC}"
else
    echo -e "${YELLOW}⚠ Completed with issues:${NC}"
    echo -e "  ${GREEN}Success:${NC} $SUCCESS"
    echo -e "  ${RED}Failed:${NC}  $FAILED"
    echo ""
    echo -e "${YELLOW}Try running with verbose output:${NC}"
    echo -e "  stow --verbose=2 --restow <package-name>"
fi

echo -e "${BLUE}════════════════════════════════════${NC}"
echo ""

# Show usage examples
if [ $# -eq 0 ]; then
    echo -e "${CYAN}Tip:${NC} Restow specific packages only:"
    echo -e "  ./restow.sh zsh hypr"
    echo ""
fi
