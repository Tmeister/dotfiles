# Dependencies

This document lists all programs required by the Hyprland configuration.

## Quick Install

```bash
# Install all critical dependencies
cd ~/.dotfiles
./install-deps.sh

# Or install manually
./install-deps.sh --manual
```

## Critical Dependencies

These are **required** for core functionality:

| Program | Purpose | Install | Source |
|---------|---------|---------|--------|
| **zsh** | Shell (dotfiles use .zshrc, Omarchy defaults to bash) | `pacman -S zsh` | Official |
| **vicinae** | Application launcher (SUPER+SPACE) | `yay -S vicinae` | AUR |
| **cliphist** | Clipboard history backend | `pacman -S cliphist` | Official |
| **wl-clipboard** | Wayland clipboard (wl-paste, wl-copy) | `pacman -S wl-clipboard` | Official |
| **walker** | Clipboard UI selector | `pacman -S walker` | Official |
| **jq** | JSON parsing (resolution toggle) | `pacman -S jq` | Official |
| **wireplumber** | Audio control (wpctl) | `pacman -S wireplumber` | Official |
| **pipewire-pulse** | Audio streams (pactl) | `pacman -S pipewire-pulse` | Official |
| **libnotify** | Desktop notifications | `pacman -S libnotify` | Official |
| **xdg-utils** | Terminal exec | `pacman -S xdg-utils` | Official |
| **fuzzel** | Rofimoji selector | `pacman -S fuzzel` | Official |
| **rofimoji** | Emoji picker (SUPER+.) | `pacman -S rofimoji` | Official |
| **hyprpicker** | Color picker (CTRL+HOME) | `pacman -S hyprpicker` | Official |

## Optional Applications

Pick what you want:

| Program | Purpose | Install | Binding |
|---------|---------|---------|---------|
| **nautilus** | File manager | `pacman -S nautilus` | SUPER+SHIFT+F |
| **btop** | System monitor | `pacman -S btop` | SUPER+SHIFT+T |
| **lazydocker** | Docker TUI | `pacman -S lazydocker` | SUPER+SHIFT+D |
| **signal-desktop** | Messaging | `pacman -S signal-desktop` | SUPER+SHIFT+G |
| **obsidian** | Note-taking | `pacman -S obsidian` | SUPER+SHIFT+O |
| **inkdrop** | Note-taking | `yay -S inkdrop` | SUPER+SHIFT+I |
| **1password** | Password manager | `yay -S 1password` | SUPER+SHIFT+/ |
| **spotify** | Music player | `pacman -S spotify-launcher` | SUPER+SHIFT+M |

## Omarchy-Provided

These come with omarchy (already installed):

- `hyprland` / `hyprctl` - Window manager control
- `omarchy-cmd-screenshot` - Screenshots
- `omarchy-launch-browser` - Browser launcher
- `omarchy-launch-editor` - Editor launcher
- `omarchy-launch-webapp` - Web app launcher
- `uwsm` - Wayland session manager

## Usage by Feature

### Launcher (SUPER+SPACE)
- **vicinae** ⚠️ CRITICAL
- **walker** (omarchy fallback)

### Clipboard Manager (SUPER+;)
- **cliphist** ⚠️ CRITICAL
- **wl-clipboard** ⚠️ CRITICAL
- **walker** ⚠️ CRITICAL

### Emoji Picker (SUPER+.)
- **rofimoji** (recommended)
- **fuzzel** (recommended)

### Resolution Toggle (SUPER+S)
- **hyprctl** (omarchy-provided)
- **jq** ⚠️ CRITICAL

### Audio Switching (SUPER+ALT+0)
- **wireplumber** ⚠️ CRITICAL
- **pipewire-pulse** ⚠️ CRITICAL

### Screenshots (HOME key)
- **omarchy-cmd-screenshot** (omarchy-provided)

### Color Picker (CTRL+HOME)
- **hyprpicker** (recommended)

## Install Scripts

### Automatic (Recommended)

```bash
cd ~/.dotfiles
./install-deps.sh
```

Features:
- ✅ Checks what's already installed
- ✅ Skips installed packages
- ✅ Prompts for AUR helper choice
- ✅ **Automatically offers to change shell to zsh** (Omarchy defaults to bash)
- ✅ Optionally installs applications
- ✅ Idempotent (safe to run multiple times)

### Manual Installation

```bash
# Critical dependencies (official repos)
sudo pacman -S zsh cliphist wl-clipboard walker hyprpicker jq \
  wireplumber pipewire-pulse libnotify xdg-utils fuzzel rofimoji

# Critical AUR dependency
yay -S vicinae

# Change default shell to zsh (if not already - Omarchy defaults to bash)
# Note: install-deps.sh does this automatically, but if installing manually:
chsh -s /usr/bin/zsh
# Logout/login required for shell change to take effect

# Optional applications (pick what you want)
sudo pacman -S nautilus btop lazydocker signal-desktop obsidian spotify-launcher
yay -S inkdrop 1password
```

## Checking Installed Packages

```bash
# Check if a package is installed
pacman -Q package-name

# Check all critical dependencies
for pkg in zsh cliphist wl-clipboard walker hyprpicker jq wireplumber \
pipewire-pulse libnotify xdg-utils fuzzel rofimoji; do
  pacman -Q $pkg 2>/dev/null || echo "Missing: $pkg"
done

# Check vicinae (AUR)
pacman -Q vicinae 2>/dev/null || echo "Missing: vicinae (AUR)"

# Check default shell
echo "Current shell: $SHELL"
[ "$SHELL" = "/usr/bin/zsh" ] && echo "✓ Using zsh" || echo "⚠ Not using zsh - run: chsh -s /usr/bin/zsh"
```

## Troubleshooting

### Shell Not ZSH
```bash
# Check current shell
echo $SHELL

# If not /usr/bin/zsh, change it
chsh -s /usr/bin/zsh

# Logout/login for change to take effect
# Or start zsh manually for testing
zsh
```

**Why this matters:** Omarchy defaults to bash, but these dotfiles use .zshrc (zsh configuration). Without changing the shell, your customizations won't load.

### Vicinae Not Found
```bash
yay -S vicinae
# or
paru -S vicinae
```

### Clipboard Not Working
```bash
# Check if cliphist service is running
pgrep -f "wl-paste.*cliphist"

# Restart cliphist watchers
pkill -f "wl-paste.*cliphist"
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
```

### Resolution Toggle Fails
```bash
# Install jq
sudo pacman -S jq

# Test hyprctl
hyprctl monitors
```

### Audio Switching Not Working
```bash
# Check audio system
wpctl status

# Install missing packages
sudo pacman -S wireplumber pipewire-pulse
```

## Alternative Packages

If you prefer different tools:

| Default | Alternative | Notes |
|---------|-------------|-------|
| vicinae | wofi, rofi-wayland | Change SUPER+SPACE binding |
| rofimoji | wofi-emoji | Update SUPER+. binding |
| nautilus | thunar, dolphin, nnn | Update SUPER+SHIFT+F |
| btop | htop, bottom | Update SUPER+SHIFT+T |

## Related Files

- `install-deps.sh` - Automatic dependency installer
- `HYPR-OVERRIDES.md` - Configuration documentation
- `README.md` - General documentation
