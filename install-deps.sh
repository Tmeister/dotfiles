#!/usr/bin/env bash
#
# install-deps.sh - Install Hyprland configuration dependencies
#
# Usage:
#   ./install-deps.sh           # Interactive installation
#   ./install-deps.sh --minimal # Only critical dependencies
#   ./install-deps.sh --all     # Include optional applications
#   ./install-deps.sh --check   # Check what's installed
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Critical dependencies from official repos
CRITICAL_PACMAN=(
    "zsh"                # ZSH shell (dotfiles use .zshrc)
    "cliphist"           # Clipboard history backend
    "wl-clipboard"       # Wayland clipboard (wl-paste, wl-copy)
    "walker"             # Clipboard UI selector
    "hyprpicker"         # Color picker
    "jq"                 # JSON parsing (resolution toggle)
    "wireplumber"        # Audio control (wpctl)
    "pipewire-pulse"     # Audio streams (pactl)
    "libnotify"          # Desktop notifications
    "xdg-utils"          # Terminal exec
    "fuzzel"             # Rofimoji selector
    "rofimoji"           # Emoji picker
)

# Critical AUR dependencies
CRITICAL_AUR=(
    "vicinae"            # Application launcher
)

# Optional applications (official repos)
OPTIONAL_PACMAN=(
    "nautilus"           # File manager (SUPER+SHIFT+F)
    "btop"               # System monitor (SUPER+SHIFT+T)
    "lazydocker"         # Docker TUI (SUPER+SHIFT+D)
    "signal-desktop"     # Messaging (SUPER+SHIFT+G)
    "obsidian"           # Note-taking (SUPER+SHIFT+O)
    "spotify-launcher"   # Music player (SUPER+SHIFT+M)
)

# Optional applications (AUR)
OPTIONAL_AUR=(
    "inkdrop"            # Note-taking (SUPER+SHIFT+I)
    "1password"          # Password manager (SUPER+SHIFT+/)
)

MODE="interactive"
AUR_HELPER=""

show_usage() {
    echo -e "${BLUE}install-deps.sh${NC} - Install Hyprland configuration dependencies"
    echo ""
    echo "Usage:"
    echo "  ./install-deps.sh           # Interactive installation (recommended)"
    echo "  ./install-deps.sh --minimal # Only critical dependencies"
    echo "  ./install-deps.sh --all     # Critical + optional applications"
    echo "  ./install-deps.sh --check   # Check what's installed"
    echo "  ./install-deps.sh --help    # Show this help"
    echo ""
}

check_installed() {
    local pkg=$1
    pacman -Q "$pkg" &>/dev/null
}

detect_aur_helper() {
    if command -v yay &>/dev/null; then
        echo "yay"
    elif command -v paru &>/dev/null; then
        echo "paru"
    else
        echo ""
    fi
}

install_aur_helper() {
    echo -e "${YELLOW}No AUR helper detected (yay or paru)${NC}"
    echo ""
    echo "AUR helper is required to install: ${CYAN}vicinae${NC} (critical launcher)"
    echo ""
    echo "Would you like to install yay?"
    read -p "Install yay? (y/N) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Installing yay...${NC}"

        # Install dependencies
        sudo pacman -S --needed git base-devel

        # Clone and build yay
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm

        AUR_HELPER="yay"
        echo -e "${GREEN}✓ yay installed${NC}"
        echo ""
    else
        echo -e "${RED}Cannot proceed without AUR helper${NC}"
        echo "Please install yay or paru manually:"
        echo "  https://github.com/Jguer/yay"
        echo "  https://github.com/morganamilo/paru"
        exit 1
    fi
}

check_dependencies() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      Dependency Status Check                     ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${YELLOW}Critical Dependencies (Official Repos):${NC}"
    local missing_pacman=0
    for pkg in "${CRITICAL_PACMAN[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')
        local desc=$(echo "$pkg" | cut -d'#' -f2- -s | xargs)

        if check_installed "$name"; then
            echo -e "  ${GREEN}✓${NC} ${CYAN}$name${NC}"
        else
            echo -e "  ${RED}✗${NC} ${CYAN}$name${NC} - $desc"
            missing_pacman=$((missing_pacman + 1))
        fi
    done
    echo ""

    echo -e "${YELLOW}Critical Dependencies (AUR):${NC}"
    local missing_aur=0
    for pkg in "${CRITICAL_AUR[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')
        local desc=$(echo "$pkg" | cut -d'#' -f2- -s | xargs)

        if check_installed "$name"; then
            echo -e "  ${GREEN}✓${NC} ${CYAN}$name${NC}"
        else
            echo -e "  ${RED}✗${NC} ${CYAN}$name${NC} - $desc"
            missing_aur=$((missing_aur + 1))
        fi
    done
    echo ""

    echo -e "${YELLOW}Optional Applications (Official Repos):${NC}"
    for pkg in "${OPTIONAL_PACMAN[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')

        if check_installed "$name"; then
            echo -e "  ${GREEN}✓${NC} ${CYAN}$name${NC}"
        else
            echo -e "  ${CYAN}○${NC} ${CYAN}$name${NC} (not installed)"
        fi
    done
    echo ""

    echo -e "${YELLOW}Optional Applications (AUR):${NC}"
    for pkg in "${OPTIONAL_AUR[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')

        if check_installed "$name"; then
            echo -e "  ${GREEN}✓${NC} ${CYAN}$name${NC}"
        else
            echo -e "  ${CYAN}○${NC} ${CYAN}$name${NC} (not installed)"
        fi
    done
    echo ""

    if [ $missing_pacman -eq 0 ] && [ $missing_aur -eq 0 ]; then
        echo -e "${GREEN}✓ All critical dependencies installed!${NC}"
        exit 0
    else
        echo -e "${YELLOW}⚠ Missing $missing_pacman official + $missing_aur AUR critical dependencies${NC}"
        exit 1
    fi
}

install_critical() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      Installing Critical Dependencies            ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""

    # Install from official repos
    echo -e "${YELLOW}[1/2]${NC} Installing from official repositories..."
    echo ""

    local to_install_pacman=()
    for pkg in "${CRITICAL_PACMAN[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')
        if ! check_installed "$name"; then
            to_install_pacman+=("$name")
        fi
    done

    if [ ${#to_install_pacman[@]} -gt 0 ]; then
        echo -e "${CYAN}Packages to install:${NC} ${to_install_pacman[*]}"
        echo ""
        sudo pacman -S --needed "${to_install_pacman[@]}"
        echo ""
        echo -e "${GREEN}✓ Official repo packages installed${NC}"
    else
        echo -e "${GREEN}✓ All official repo packages already installed${NC}"
    fi

    echo ""

    # Install from AUR
    echo -e "${YELLOW}[2/2]${NC} Installing from AUR..."
    echo ""

    local to_install_aur=()
    for pkg in "${CRITICAL_AUR[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')
        if ! check_installed "$name"; then
            to_install_aur+=("$name")
        fi
    done

    if [ ${#to_install_aur[@]} -gt 0 ]; then
        echo -e "${CYAN}AUR packages to install:${NC} ${to_install_aur[*]}"
        echo ""
        $AUR_HELPER -S --needed "${to_install_aur[@]}"
        echo ""
        echo -e "${GREEN}✓ AUR packages installed${NC}"
    else
        echo -e "${GREEN}✓ All AUR packages already installed${NC}"
    fi

    echo ""
}

install_optional() {
    echo -e "${YELLOW}Optional Applications${NC}"
    echo ""
    echo "Would you like to install optional applications?"
    echo "(File manager, system monitor, note-taking apps, etc.)"
    echo ""
    read -p "Install optional applications? (y/N) " -n 1 -r
    echo ""
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}→ Skipping optional applications${NC}"
        return
    fi

    # Install optional from official repos
    local to_install_pacman=()
    for pkg in "${OPTIONAL_PACMAN[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')
        if ! check_installed "$name"; then
            to_install_pacman+=("$name")
        fi
    done

    if [ ${#to_install_pacman[@]} -gt 0 ]; then
        echo -e "${CYAN}Optional packages (official):${NC} ${to_install_pacman[*]}"
        echo ""
        sudo pacman -S --needed "${to_install_pacman[@]}"
        echo ""
        echo -e "${GREEN}✓ Optional packages installed${NC}"
    fi

    # Install optional from AUR
    local to_install_aur=()
    for pkg in "${OPTIONAL_AUR[@]}"; do
        local name=$(echo "$pkg" | awk '{print $1}')
        if ! check_installed "$name"; then
            to_install_aur+=("$name")
        fi
    done

    if [ ${#to_install_aur[@]} -gt 0 ]; then
        echo -e "${CYAN}Optional AUR packages:${NC} ${to_install_aur[*]}"
        echo ""
        $AUR_HELPER -S --needed "${to_install_aur[@]}"
        echo ""
        echo -e "${GREEN}✓ Optional AUR packages installed${NC}"
    fi

    echo ""
}

change_shell_to_zsh() {
    # Check if already using zsh
    if [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
        echo -e "${GREEN}✓ Already using ZSH${NC}"
        echo ""
        return
    fi

    echo -e "${YELLOW}⚠ Your default shell is currently: $SHELL${NC}"
    echo -e "${YELLOW}  These dotfiles require ZSH.${NC}"
    echo ""
    echo -e "Would you like to change your default shell to ZSH now?"
    echo -e "${CYAN}Note: You'll need to logout/login for the change to take effect${NC}"
    echo ""
    read -p "Change shell to zsh? (Y/n) " -n 1 -r
    echo ""
    echo ""

    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${CYAN}Changing default shell to zsh...${NC}"
        if chsh -s /usr/bin/zsh; then
            echo -e "${GREEN}✓ Shell changed to zsh${NC}"
            echo -e "${YELLOW}⚠ You must logout and login for this to take effect${NC}"
            echo ""
        else
            echo -e "${RED}✗ Failed to change shell${NC}"
            echo -e "${YELLOW}You can change it manually later with: chsh -s /usr/bin/zsh${NC}"
            echo ""
        fi
    else
        echo -e "${CYAN}→ Skipping shell change${NC}"
        echo -e "${YELLOW}  Remember to change your shell later with: chsh -s /usr/bin/zsh${NC}"
        echo ""
    fi
}

show_summary() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      Installation Complete!                      ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Critical dependencies installed:${NC}"
    echo -e "  • ${GREEN}ZSH${NC} - Shell (dotfiles use .zshrc)"
    echo -e "  • ${GREEN}Vicinae${NC} - Launcher (SUPER+SPACE)"
    echo -e "  • ${GREEN}Cliphist + Walker${NC} - Clipboard manager (SUPER+;)"
    echo -e "  • ${GREEN}Rofimoji + Fuzzel${NC} - Emoji picker (SUPER+.)"
    echo -e "  • ${GREEN}Audio utilities${NC} - Audio switcher (SUPER+ALT+0)"
    echo -e "  • ${GREEN}Resolution toggle${NC} - Display switcher (SUPER+S)"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo ""
    echo -e "1. Deploy dotfiles:"
    echo -e "   ${BLUE}./install.sh${NC}"
    echo ""
    echo -e "2. Reload shell:"
    echo -e "   ${BLUE}exec zsh${NC}"
    echo ""
    echo -e "3. Reload Hyprland:"
    echo -e "   ${BLUE}hyprctl reload${NC}"
    echo ""
    echo -e "4. Test your bindings:"
    echo -e "   ${BLUE}SUPER+SPACE${NC} - Vicinae launcher"
    echo -e "   ${BLUE}SUPER+;${NC} - Clipboard manager"
    echo -e "   ${BLUE}SUPER+.${NC} - Emoji picker"
    echo ""
}

# Main script
case "${1:-}" in
    --help|-h)
        show_usage
        exit 0
        ;;
    --check|-c)
        check_dependencies
        ;;
    --minimal)
        MODE="minimal"
        ;;
    --all)
        MODE="all"
        ;;
    "")
        MODE="interactive"
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        echo ""
        show_usage
        exit 1
        ;;
esac

# Start installation
echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Hyprland Dependencies Installer                ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Detect or install AUR helper
AUR_HELPER=$(detect_aur_helper)
if [ -z "$AUR_HELPER" ]; then
    install_aur_helper
else
    echo -e "${GREEN}✓ AUR helper detected: $AUR_HELPER${NC}"
    echo ""
fi

# Install critical dependencies
install_critical

# Change shell to zsh (interactive prompt)
change_shell_to_zsh

# Install optional based on mode
case "$MODE" in
    all)
        install_optional
        ;;
    interactive)
        install_optional
        ;;
    minimal)
        echo -e "${CYAN}→ Minimal mode: Skipping optional applications${NC}"
        echo ""
        ;;
esac

# Show summary
show_summary
