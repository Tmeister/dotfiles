# Deployment Guide

## Current Status

Your dotfiles have been successfully **restructured for GNU Stow** but are **not yet deployed**.

### What's Been Done

✅ All configs restructured into stow packages
✅ GNU Stow installed and configured
✅ Helper scripts created (omarchy-diff, omarchy-customizations)
✅ Post-update hook ready for omarchy
✅ Installation and restow scripts prepared
✅ Documentation updated (README, OMARCHY.md)

### What's Still Using Old Symlinks

Your current system is still using the **old manual symlinks**:

```bash
~/.config/hypr → ~/.dotfiles/hypr  (OLD - flat structure)
```

After deployment, they will be:

```bash
~/.config/hypr → ~/.dotfiles/hypr/.config/hypr  (NEW - stow structure)
```

## Next Steps

### Option 1: Automated Deployment (Recommended)

Run the installation script which handles everything:

```bash
cd ~/.dotfiles
./install.sh
```

This will:
1. Detect conflicts with old symlinks
2. Create timestamped backups
3. Remove old symlinks
4. Deploy all packages with stow
5. Set up helper scripts and hooks

### Option 2: Manual Deployment

If you want more control:

```bash
cd ~/.dotfiles

# 1. Remove old symlinks (BE CAREFUL!)
rm ~/.config/hypr
rm ~/.config/walker
rm ~/.config/waybar
rm ~/.config/nvim
rm ~/.config/alacritty
rm ~/.config/starship.toml
rm ~/.config/ohmyposh
rm ~/.tmux.conf
rm ~/.zshrc

# 2. Stow all packages
stow zsh
stow hypr
stow walker
stow waybar
stow nvim
stow alacritty
stow ghostty
stow tmux
stow starship
stow ohmyposh
stow claude
stow scripts

# 3. Verify
ls -la ~/.config | grep '\->'
```

### Option 3: Test with Single Package First

Test with tmux (safest):

```bash
cd ~/.dotfiles

# Remove old symlink
rm ~/.tmux.conf

# Stow it
stow tmux

# Verify
ls -la ~/.tmux.conf
# Should show: .tmux.conf -> .dotfiles/tmux/.tmux.conf

# If it works, continue with other packages
```

## Verification After Deployment

### 1. Check Symlinks

```bash
ls -la ~/.config | grep '\->'
ls -la ~ | grep '\->'
```

Expected output:
```
.config/hypr -> .dotfiles/hypr/.config/hypr
.config/walker -> .dotfiles/walker/.config/walker
...
```

### 2. Test Shell

```bash
# Reload shell
exec zsh

# Check if helpers are available
which omarchy-customizations
which omarchy-diff
```

### 3. Verify Omarchy Hook

```bash
ls -la ~/.config/omarchy/hooks/post-update
# Should be a symlink to your dotfiles
```

### 4. Test Hyprland (if running)

```bash
# Reload Hyprland config
hyprctl reload
```

## Post-Deployment

### 1. Run Customization Check

```bash
omarchy-customizations
```

This will show you all active overrides and their status.

### 2. Review Documentation

- **README.md** - General usage and workflow
- **OMARCHY.md** - Detailed omarchy override documentation
- **MIGRATION.md** - Migration notes (for reference)

### 3. Commit Changes

Once everything works:

```bash
cd ~/.dotfiles
git add .
git commit -m "Migrate to GNU Stow for dotfiles management

- Restructure all packages for stow
- Add installation and restow scripts
- Create omarchy helper tools
- Add comprehensive documentation
- Set up post-update hooks"
git push
```

## Troubleshooting

### Stow Reports Conflicts

If stow says files already exist:

```bash
# Option 1: Backup and remove
mv ~/.config/hypr ~/.config/hypr.backup
stow hypr

# Option 2: Let stow adopt them
stow --adopt hypr
git diff  # Review what changed
```

### Symlinks Point to Wrong Place

```bash
# Check where symlink points
readlink -f ~/.config/hypr

# Should be: /home/tmeister/.dotfiles/hypr/.config/hypr
# If wrong, remove and restow
rm ~/.config/hypr
stow hypr
```

### Scripts Not in PATH

```bash
# Verify PATH
echo $PATH | tr ':' '\n' | grep local

# Should see ~/.local/bin near the top
# If not, reload shell
exec zsh
```

### Hyprland Config Broken

If Hyprland won't load:

```bash
# Check for errors
hyprctl reload 2>&1

# Restore backup if needed
rm ~/.config/hypr
mv ~/.config/hypr.backup ~/.config/hypr

# Or restore from omarchy
rm ~/.config/hypr
mv ~/.config/hypr.om ~/.config/hypr
```

## Rollback Plan

If something goes wrong:

### 1. Quick Rollback

```bash
cd ~/.dotfiles

# Unstow everything
stow --delete zsh hypr walker waybar nvim alacritty ghostty tmux starship ohmyposh claude scripts

# Restore from backup (if created by install.sh)
ls ~/.dotfiles-backup-* -td | head -1
# Copy files back from that directory
```

### 2. Full Rollback

```bash
# If you have omarchy backups
mv ~/.config/hypr.om ~/.config/hypr
mv ~/.config/waybar.om ~/.config/waybar
mv ~/.config/nvim.om ~/.config/nvim

# Restore shell
cp ~/.zshrc.backup ~/.zshrc  # If you made one
```

## Success Indicators

After deployment, you should see:

✅ All configs symlinked via stow
✅ `omarchy-customizations` shows your overrides
✅ Hyprland launches and works
✅ Launcher (SUPER+SPACE) works
✅ Terminal opens
✅ Shell loads without errors
✅ Helper commands available (omarchy-diff, etc.)

## Questions?

- **File not found?** Check the package structure in `~/.dotfiles/<package>/`
- **Symlink wrong?** Run `readlink -f <path>` to debug
- **Config broken?** Check `hyprctl reload` or app-specific logs
- **Need help?** Review README.md and OMARCHY.md

## Ready to Deploy?

When you're ready:

```bash
cd ~/.dotfiles
./install.sh
```

Good luck! 🚀
