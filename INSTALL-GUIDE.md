# Installation Guide - Complete Process

This guide covers the **complete installation order** from start to finish.

## Scenario 1: Fresh Omarchy Install (New Machine)

### Prerequisites
- Omarchy already installed on the system
- Git installed (`sudo pacman -S git`)

**Important Notes:**
- Omarchy defaults to **bash** as the shell
- These dotfiles use **zsh** (.zshrc configuration)
- The `install-deps.sh` script will automatically offer to change your shell to zsh
- You'll need to logout/login after changing shells

### Step-by-Step Process

#### 1. Clone Dotfiles
```bash
cd ~
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

**What this does:** Downloads your dotfiles repository

---

#### 2. Install GNU Stow
```bash
sudo pacman -S stow
```

**What this does:** Installs the symlink manager

**Verify:**
```bash
stow --version
# Should show: stow (GNU Stow) version 2.4.1
```

---

#### 3. Install Dependencies
```bash
./install-deps.sh
```

**What this does:**
- Detects/installs AUR helper (yay or paru)
- Installs critical programs:
  - zsh (shell for dotfiles)
  - vicinae (launcher)
  - cliphist, wl-clipboard, walker (clipboard)
  - rofimoji, fuzzel (emoji)
  - jq, wireplumber, pipewire-pulse (scripts)
  - hyprpicker, libnotify, xdg-utils
- **Automatically offers to change shell to zsh** (if not already zsh)
- Optionally installs applications (nautilus, btop, etc.)

**⚠️ Shell Change Note:**
- Omarchy defaults to **bash**, these dotfiles use **zsh**
- The script will prompt to change your shell automatically
- You'll need to **logout/login** after the shell change
- If you decline, you can change manually later with: `chsh -s /usr/bin/zsh`

**Verify:**
```bash
./install-deps.sh --check
# Should show all critical dependencies installed
```

**Alternative (manual):**
```bash
# Critical only
./install-deps.sh --minimal

# Everything
./install-deps.sh --all
```

---

#### 4. Deploy Dotfiles with Stow
```bash
./install.sh
```

**What this does:**
1. Checks for conflicts with existing files
2. Creates timestamped backups
3. Creates necessary directories
4. Stows all packages (creates symlinks):
   - `zsh` → `~/.zshrc`
   - `hypr` → `~/.config/hypr/`
   - `walker` → `~/.config/walker/`
   - `waybar` → `~/.config/waybar/`
   - `nvim` → `~/.config/nvim/`
   - `scripts` → `~/.local/bin/`
   - `tmux` → `~/.tmux.conf`
   - etc.
5. Makes scripts executable
6. Sets up omarchy post-update hook
7. **Seeds Hyprland config** with `omarchy-seed-config`

**Verify:**
```bash
# Check symlinks created
ls -la ~/.config | grep '\->'
# Should show: hypr, walker, waybar, nvim, etc.

# Check scripts available
which omarchy-seed-config
which omarchy-customizations
which omarchy-diff
```

---

#### 5. Reload Shell
```bash
exec zsh
```

**What this does:**
- Loads new `.zshrc` configuration
- Activates PATH with `~/.local/bin` first
- Initializes zinit and plugins

**Verify:**
```bash
# Check PATH includes ~/.local/bin
echo $PATH | grep -o "$HOME/.local/bin"

# Check omarchy helpers work
omarchy-customizations
```

---

#### 6. Verify Hyprland Override Seeding
```bash
omarchy-seed-config --check
```

**Expected output:**
```
✓ Config is already seeded
```

**If not seeded:**
```bash
omarchy-seed-config
```

**What this does:**
- Injects 7 override source lines into `~/.config/hypr/hyprland.conf`
- Creates backup before modifying
- Makes your customizations load after omarchy defaults

**Verify:**
```bash
grep -A7 "DOTFILES OVERRIDES" ~/.config/hypr/hyprland.conf
# Should show 7 source lines for override files
```

---

#### 7. Reload Hyprland
```bash
hyprctl reload
```

**Or via menu:**
- Press `SUPER + ESC`
- Select "Relaunch"

**What this does:**
- Reloads all Hyprland configs
- Activates your overrides
- Applies custom bindings

---

#### 8. Test Your Customizations

Test each critical feature:

```bash
# Launcher
SUPER + SPACE        # Should open Vicinae (not omarchy-menu)

# Screenshots (75% keyboard)
HOME                 # Screenshot with editing
SHIFT + HOME         # Screenshot to clipboard

# Clipboard Manager
SUPER + ;            # Opens walker with clipboard history

# Emoji Picker
SUPER + .            # Opens rofimoji with fuzzel

# Resolution Toggle
SUPER + S            # Cycles display scaling

# Audio Switcher
SUPER + ALT + 0      # Toggles audio output device

# Color Picker
CTRL + HOME          # Activates hyprpicker
```

**If something doesn't work:**
```bash
# Check dependencies
./install-deps.sh --check

# Check override files exist
ls -la ~/.config/hypr/overrides/

# Check if seeded
omarchy-seed-config --check

# View configuration status
omarchy-customizations
```

---

## Scenario 2: Existing Dotfiles Update

If you already have dotfiles installed and want to update:

#### 1. Pull Latest Changes
```bash
cd ~/.dotfiles
git pull
```

#### 2. Install Any New Dependencies
```bash
./install-deps.sh --check    # See what's missing
./install-deps.sh             # Install missing deps
```

#### 3. Restow Packages
```bash
./restow.sh                   # Restow everything
# OR
./restow.sh hypr scripts      # Restow specific packages
```

#### 4. Verify Seed Status
```bash
omarchy-seed-config --check
```

#### 5. Reload
```bash
exec zsh              # Reload shell
hyprctl reload        # Reload Hyprland
```

---

## Scenario 3: After Omarchy Update

When you run `omarchy-update`, the system handles it automatically:

#### What Happens Automatically

1. **Omarchy updates** its files in `~/.local/share/omarchy/`
2. **Post-update hook** runs automatically:
   - Verifies symlinks intact
   - Re-seeds Hyprland config
   - Shows what changed in omarchy
   - Checks PATH precedence

#### Manual Steps (Optional)

```bash
# Review what changed in omarchy
omarchy-diff

# Compare specific configs
omarchy-diff hypr

# See your active overrides
omarchy-customizations

# Reload Hyprland
hyprctl reload
```

---

## Execution Order Summary

### Fresh Install (Complete Order)

```bash
# 1. Prerequisites
sudo pacman -S git stow

# 2. Clone dotfiles
git clone <repo> ~/.dotfiles && cd ~/.dotfiles

# 3. Install dependencies (includes zsh, offers to change shell)
./install-deps.sh
# Script will prompt: "Change shell to zsh? (Y/n)"
# If yes, logout/login required before continuing

# 4. Deploy dotfiles (includes seeding)
./install.sh

# 5. Reload shell
exec zsh

# 6. Verify seeding
omarchy-seed-config --check

# 7. Reload Hyprland
hyprctl reload

# 8. Test features
# SUPER+SPACE, SUPER+;, SUPER+., etc.
```

### Update Existing

```bash
cd ~/.dotfiles
git pull
./install-deps.sh --check
./restow.sh
exec zsh
hyprctl reload
```

### After Omarchy Update

```bash
# Automatic via hook, but verify:
omarchy-diff
hyprctl reload
```

---

## Troubleshooting Order

If something doesn't work after installation:

#### 1. Check Dependencies
```bash
./install-deps.sh --check
```

**Fix:** Run `./install-deps.sh` to install missing packages

#### 2. Check Symlinks
```bash
ls -la ~/.config/hypr
# Should be a symlink to ~/.dotfiles/hypr/.config/hypr
```

**Fix:**
```bash
cd ~/.dotfiles
./restow.sh hypr
```

#### 3. Check Override Files
```bash
ls -la ~/.config/hypr/overrides/
# Should show 7 .conf files
```

**Fix:**
```bash
cd ~/.dotfiles
./restow.sh hypr
```

#### 4. Check Seeding
```bash
omarchy-seed-config --check
```

**Fix:**
```bash
omarchy-seed-config
```

#### 5. Check Scripts in PATH
```bash
which omarchy-seed-config
which omarchy-customizations
```

**Fix:**
```bash
cd ~/.dotfiles
./restow.sh scripts
exec zsh
```

#### 6. Check Hyprland Config Syntax
```bash
hyprctl reload
# Look for errors in output
```

**Fix:**
```bash
# Check override files for syntax errors
nvim ~/.config/hypr/overrides/bindings.conf
```

---

## Critical Files Check

After installation, these should all exist:

```bash
# Dotfiles symlinks
~/.zshrc → ~/.dotfiles/zsh/.zshrc
~/.config/hypr → ~/.dotfiles/hypr/.config/hypr
~/.config/walker → ~/.dotfiles/walker/.config/walker
~/.local/bin/omarchy-seed-config → ~/.dotfiles/scripts/.local/bin/omarchy-seed-config

# Override files (via hypr symlink)
~/.config/hypr/overrides/bindings.conf
~/.config/hypr/overrides/monitors.conf
~/.config/hypr/overrides/workspaces.conf
~/.config/hypr/overrides/windows.conf
~/.config/hypr/overrides/input.conf
~/.config/hypr/overrides/envs.conf
~/.config/hypr/overrides/autostart.conf

# Seeded config
~/.config/hypr/hyprland.conf (contains "DOTFILES OVERRIDES" marker)

# Helper scripts
~/.local/bin/omarchy-seed-config
~/.local/bin/omarchy-diff
~/.local/bin/omarchy-customizations
~/.local/bin/tmux-sessionizer

# Omarchy hook
~/.config/omarchy/hooks/post-update
```

**Verification command:**
```bash
omarchy-customizations
# Shows complete status of your setup
```

---

## What NOT to Do

❌ **Don't run in wrong order:**
```bash
# BAD: Installing before dependencies
./install.sh                 # Will work but features won't
./install-deps.sh            # Should be done first
```

❌ **Don't skip reload steps:**
```bash
# BAD: Not reloading after changes
./install.sh
# Missing: exec zsh
# Missing: hyprctl reload
```

❌ **Don't manually edit hyprland.conf:**
```bash
# BAD: Manual editing
nvim ~/.config/hypr/hyprland.conf
# Add source lines manually

# GOOD: Use seed script
omarchy-seed-config
```

❌ **Don't forget to commit after testing:**
```bash
# After verifying everything works:
cd ~/.dotfiles
git add .
git commit -m "Initial setup complete"
git push
```

---

## Quick Reference Card

### Initial Setup (Fresh Omarchy)
```bash
# Install dependencies (prompts to change shell automatically)
./install-deps.sh
# Answer "Y" to change shell to zsh
# Logout/login after shell change

# Then deploy dotfiles
./install.sh && exec zsh
# Then reload Hyprland (SUPER+ESC → Relaunch)
```

### Update (2 commands)
```bash
git pull && ./restow.sh && exec zsh
# Then reload Hyprland
```

### Verify (1 command)
```bash
omarchy-customizations
```

---

## Timeline Estimate

- **Dependencies install:** 5-10 minutes (AUR builds)
- **Dotfiles deploy:** < 1 minute
- **Testing features:** 2-3 minutes
- **Total:** ~15 minutes for fresh install

---

## Related Documentation

- [`DEPENDENCIES.md`](./DEPENDENCIES.md) - What programs you need
- [`README.md`](./README.md) - General overview
- [`HYPR-OVERRIDES.md`](./HYPR-OVERRIDES.md) - How overrides work
- [`OMARCHY.md`](./OMARCHY.md) - Omarchy integration details
