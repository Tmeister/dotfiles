# Hyprland Override System

This document explains how the modular override system works to preserve your Hyprland customizations during omarchy updates.

## The Problem

When running `omarchy-update`, omarchy may update its default configs in `~/.local/share/omarchy/`. While your symlinked `~/.config/hypr/` directory is protected, you would previously need to:

1. Re-edit configuration files after updates
2. Manually track which settings you customized
3. Risk losing changes if you forgot what you modified

## The Solution

**Modular Override System** - Separate your customizations into dedicated override files that:
- ✅ Are sourced AFTER omarchy defaults (so they take precedence)
- ✅ Are managed by your dotfiles (version controlled)
- ✅ Are automatically re-seeded after omarchy updates
- ✅ Are clearly documented and organized

## Architecture

### File Structure

```
~/.config/hypr/
├── hyprland.conf           # Main config (sources omarchy + overrides)
├── overrides/              # Your customizations (managed by dotfiles)
│   ├── bindings.conf       # Keybinding overrides
│   ├── monitors.conf       # Monitor configuration
│   ├── workspaces.conf     # Workspace assignments
│   ├── windows.conf        # Window rules and styling
│   ├── input.conf          # Input device settings
│   ├── envs.conf           # Environment variables
│   └── autostart.conf      # Startup applications
└── scripts/                # Custom helper scripts
    ├── clipboard-walker.sh
    ├── resolution-toggle.sh
    └── switch-audio.sh
```

### Source Order (in hyprland.conf)

```conf
# 1. Omarchy Defaults (lines 4-13)
source = ~/.local/share/omarchy/default/hypr/autostart.conf
source = ~/.local/share/omarchy/default/hypr/bindings/media.conf
source = ~/.local/share/omarchy/default/hypr/bindings/clipboard.conf
source = ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf
source = ~/.local/share/omarchy/default/hypr/bindings/utilities.conf
source = ~/.local/share/omarchy/default/hypr/envs.conf
source = ~/.local/share/omarchy/default/hypr/looknfeel.conf
source = ~/.local/share/omarchy/default/hypr/input.conf
source = ~/.local/share/omarchy/default/hypr/windows.conf
source = ~/.config/omarchy/current/theme/hyprland.conf

# 2. DOTFILES OVERRIDES - Managed by omarchy-seed-config
# These are sourced AFTER omarchy, so they override defaults
source = ~/.config/hypr/overrides/bindings.conf
source = ~/.config/hypr/overrides/monitors.conf
source = ~/.config/hypr/overrides/workspaces.conf
source = ~/.config/hypr/overrides/windows.conf
source = ~/.config/hypr/overrides/input.conf
source = ~/.config/hypr/overrides/envs.conf
source = ~/.config/hypr/overrides/autostart.conf

# 3. Legacy user configs (kept for compatibility - can be removed)
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/workspaces.conf
# ... etc
```

**Key Insight**: Overrides are sourced AFTER omarchy defaults, so any duplicate settings in your overrides take precedence.

## Override Files Explained

### 1. bindings.conf - Keybinding Overrides

**Critical customizations:**
- `unbind = SUPER, SPACE` - Remove omarchy-menu launcher
- `bindd = SUPER, SPACE, Vicinae Launcher, exec, vicinae toggle` - Add Vicinae
- HOME key screenshots (75% keyboard support)
- Custom scripts (clipboard, resolution, audio)
- Web app launchers

**What it overrides:**
- omarchy's launcher binding
- omarchy's screenshot bindings (PRINT key)
- Adds custom application launchers

### 2. monitors.conf - Display Configuration

**Your setup:**
- Samsung LU28R55 28" 4K (DP-1) at 1.5x scale
- Mini monitor 1080p (HDMI-A-1) below primary
- Vertical arrangement

**What it overrides:**
- omarchy's default monitor auto-detection
- Adds specific positioning and scaling

### 3. workspaces.conf - Workspace Assignments

**Your setup:**
- Workspaces 1-5 → Samsung monitor (DP-1)
- Workspaces 6-10 → Mini monitor (HDMI-A-1)

**What it overrides:**
- omarchy's default workspace distribution

### 4. windows.conf - Window Rules & Styling

**Key rules:**
- Vicinae layer rules (blur, noanim)
- JetBrains/Android Studio fixes (tooltips, tab dragging)
- File dialog float rules
- Custom border and decoration styling

**What it overrides:**
- omarchy's window decoration settings
- Adds IDE-specific fixes

### 5. input.conf - Input Device Configuration

**Your settings:**
- Compose key on CapsLock
- Keyboard repeat rate: 40
- Logitech MX Master 3S natural scroll
- Terminal touchpad scroll factor

**What it overrides:**
- omarchy's default input settings

### 6. envs.conf - Environment Variables

**Your variables:**
- Font rendering optimizations (FREETYPE_PROPERTIES)
- Qt DPI settings
- Java/JetBrains Wayland fixes

**What it extends:**
- Adds to omarchy's environment variables

### 7. autostart.conf - Startup Applications

**Your apps:**
- Vicinae server
- Cliphist clipboard manager (text + images)

**What it extends:**
- Adds to omarchy's autostart apps

## The omarchy-seed-config Script

### What It Does

1. **Verifies** omarchy is installed
2. **Creates backup** of hyprland.conf
3. **Checks** if already seeded (idempotent)
4. **Injects** override source lines after omarchy defaults
5. **Verifies** all override files exist

### Usage

```bash
# Seed the configuration
omarchy-seed-config

# Just check if already seeded
omarchy-seed-config --check

# Show help
omarchy-seed-config --help
```

### When It Runs

- **Manual**: Run anytime to seed overrides
- **Install**: Automatically during `./install.sh`
- **Post-update**: Automatically after `omarchy-update` (via hook)

### Idempotent Design

Safe to run multiple times:
- ✅ Won't add duplicate source lines
- ✅ Creates timestamped backups
- ✅ Exits gracefully if already seeded

## Workflow

### Fresh Omarchy Install

```bash
# 1. Install omarchy
omarchy-install

# 2. Deploy dotfiles
cd ~/.dotfiles
./install.sh

# 3. Seed will run automatically

# 4. Reload Hyprland
hyprctl reload
```

### After Omarchy Updates

```bash
# 1. Run omarchy update
omarchy-update

# 2. Post-update hook runs automatically:
#    - Verifies symlinks
#    - Re-seeds config
#    - Shows what changed

# 3. Review changes if needed
omarchy-diff

# 4. Reload Hyprland
hyprctl reload
```

### Manual Re-seeding

If you ever need to manually re-seed:

```bash
# Check status
omarchy-seed-config --check

# Re-seed (creates backup first)
omarchy-seed-config

# Reload Hyprland
hyprctl reload
```

## Maintenance

### Adding New Overrides

1. Edit the appropriate override file:
   ```bash
   nvim ~/.dotfiles/hypr/.config/hypr/overrides/bindings.conf
   ```

2. Changes are immediately active (symlinked)

3. Commit to git:
   ```bash
   cd ~/.dotfiles
   git add hypr/.config/hypr/overrides/
   git commit -m "Add new keybinding for..."
   ```

### Reviewing Omarchy Changes

After updates, check what changed:

```bash
# See recent omarchy changes
omarchy-diff

# Compare specific configs
omarchy-diff hypr

# See all your overrides
omarchy-customizations
```

### Merging Useful Omarchy Improvements

If omarchy adds something you want:

1. Check their defaults:
   ```bash
   cat ~/.local/share/omarchy/default/hypr/bindings/utilities.conf
   ```

2. Add to your override if desired:
   ```bash
   nvim ~/.dotfiles/hypr/.config/hypr/overrides/bindings.conf
   ```

3. Reload Hyprland:
   ```bash
   hyprctl reload
   ```

## Troubleshooting

### Override Files Not Loading

**Check if seeded:**
```bash
omarchy-seed-config --check
```

**Re-seed:**
```bash
omarchy-seed-config
hyprctl reload
```

### Changes Not Taking Effect

**Verify file exists:**
```bash
ls -la ~/.config/hypr/overrides/
```

**Check if symlinked:**
```bash
readlink -f ~/.config/hypr
# Should show: /home/tmeister/.dotfiles/hypr/.config/hypr
```

**Reload Hyprland:**
```bash
hyprctl reload
```

### Source Lines Missing After Update

**Check post-update hook:**
```bash
cat ~/.config/omarchy/hooks/post-update
```

**Manually re-seed:**
```bash
omarchy-seed-config
```

## Benefits

✅ **Survives Updates** - Overrides protected from omarchy updates
✅ **Version Controlled** - All in git, track history
✅ **Modular** - Easy to see what you've customized
✅ **Documented** - Each file explains what it does
✅ **Automatic** - Post-update hook re-seeds automatically
✅ **Idempotent** - Safe to run seed script multiple times
✅ **Portable** - Works on fresh installs via install.sh

## Related Documentation

- `README.md` - Main dotfiles documentation
- `OMARCHY.md` - Complete omarchy integration guide
- `MIGRATION.md` - Stow migration notes

## Helper Commands

```bash
# View all customizations
omarchy-customizations

# Compare with omarchy
omarchy-diff
omarchy-diff hypr

# Check seed status
omarchy-seed-config --check

# Re-seed config
omarchy-seed-config

# Reload Hyprland
hyprctl reload
```

## Summary

The override system gives you:
1. **Clear separation** between omarchy defaults and your customizations
2. **Automatic protection** during omarchy updates
3. **Easy maintenance** with documented, modular files
4. **Version control** via git
5. **Portability** for fresh installs

Your critical customizations (Vicinae launcher, 75% keyboard, custom scripts, dual monitor setup) are now permanently protected!
