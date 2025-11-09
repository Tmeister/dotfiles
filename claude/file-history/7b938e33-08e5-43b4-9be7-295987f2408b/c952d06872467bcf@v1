# Dotfiles

Personal dotfiles configuration for Arch Linux with Hyprland and Omarchy.

## Walker Launcher Customizations

### Raycast-Inspired Theme
Custom Walker theme that mimics Raycast's clean, modern design with dynamic Omarchy colors.

#### Files

##### Theme Files
- `~/.config/walker/custom-theme.css` - Main Walker launcher theme (Super + Space)
- `~/.config/walker/omarchy-menu.css` - Omarchy menu theme (Ctrl + Alt + Space)
- `~/.config/walker/omarchy-menu.toml` - Menu sizing and configuration
- `~/.config/walker/config.toml` - Walker configuration with theme settings

##### Scripts
- `~/dotfiles/bin/omarchy-menu` - Custom omarchy-menu script with theme override
- `~/.local/bin/omarchy-menu` → symlink to above (for PATH priority)

#### Features
- **Raycast-style design** with rounded corners (4px radius)
- **Dynamic colors** from Omarchy theme (`@base`, `@text`, `@selected-text`, `@border`)
- **Dark semi-transparent background** with backdrop blur
- **Clean typography** using Liberation Sans font
- **Subtle hover effects** (5-6% opacity)
- **Minimal scrollbar** design
- **No animations** for instant response

#### Setup

1. **Walker Main Launcher** (Super + Space)
   - Uses `custom-theme` specified in `config.toml`
   - Automatically loads from `~/.config/walker/`

2. **Omarchy Menu** (Ctrl + Alt + Space)  
   - Modified `/home/tmeister/.local/share/omarchy/bin/omarchy-menu` to use `omarchy-menu` theme
   - Custom script in `~/dotfiles/bin/omarchy-menu` preserves changes

#### Preserving Changes After Omarchy Updates

**⚠️ Important:** The file `/home/tmeister/.local/share/omarchy/bin/omarchy-menu` will be overwritten during Omarchy updates.

To restore customizations after an update:
```bash
# Either copy our custom version
cp ~/dotfiles/bin/omarchy-menu /home/tmeister/.local/share/omarchy/bin/omarchy-menu

# Or just change the theme line
sed -i 's/--theme dmenu_250/--theme omarchy-menu/g' /home/tmeister/.local/share/omarchy/bin/omarchy-menu
```

#### Theme Variables
The themes use Omarchy's dynamic color variables:
- `@base` - Background color
- `@text` - Primary text color  
- `@selected-text` - Selection/highlight color
- `@border` - Border color
- `alpha()` function for opacity

## Hyprland Bindings

### Custom Application Bindings
- `Super + I` - Inkdrop
- `Super + L` - DeepL translator
- `Super + .` - Emoji picker (rofimoji with fuzzel)
- `Super + ;` - Clipboard manager (with auto-paste)
- `Super + S` - Resolution toggle (cycles through 1.25x, 1.5x, 2.0x scaling)

### Web App Bindings
All web apps use Chromium with `--app` flag for clean window:
- `Super + A` - ChatGPT
- `Super + C` - Claude
- `Super + E` - Gmail
- `Super + Y` - YouTube
- `Super + X` - X/Twitter
- `Super + Shift + X` - X Post composer
- `Super + Shift + G` - WhatsApp
- `Super + Alt + G` - Google Messages

## Additional Tools

### Emoji Picker
- **Package:** `rofimoji` with `fuzzel` selector
- **Keybinding:** Super + . (period)
- **Action:** Types emoji directly into focused field

### Clipboard Manager
- **Script:** `~/.config/hypr/scripts/clipboard-walker.sh`
- **Keybinding:** Super + ; (semicolon)
- **Features:** Auto-pastes selection to focused field

## Waybar Customizations
- **Config:** `~/.config/waybar/config.jsonc`
- **Styles:** `~/.config/waybar/style.css`
- Darker background (65% opacity)
- Custom Omarchy menu icon and update indicator

## Font Configuration
- **System font:** Liberation Sans
- **Monospace:** JetBrains Mono NL
- **Config:** `~/.config/fontconfig/fonts.conf`