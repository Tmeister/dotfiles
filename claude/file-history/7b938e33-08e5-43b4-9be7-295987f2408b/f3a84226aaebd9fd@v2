# Stow Migration Documentation

## Current Symlink Setup (Pre-Stow)

This document records the original symlink configuration before migrating to GNU Stow.

### Home Directory Symlinks
- `~/.tmux.conf` → `~/.dotfiles/tmux.conf`
- `~/.claude` → `~/.dotfiles/claude`

### ~/.config Directory Symlinks
- `~/.config/alacritty` → `~/.dotfiles/alacritty`
- `~/.config/hypr` → `~/.dotfiles/hypr`
- `~/.config/nvim` → `~/.dotfiles/nvim`
- `~/.config/ohmyposh` → `~/.dotfiles/ohmyposh`
- `~/.config/starship.toml` → `~/.dotfiles/starship.toml`
- `~/.config/walker` → `~/.dotfiles/walker`
- `~/.config/waybar` → `~/.dotfiles/waybar`

### Files NOT Currently Symlinked
- `~/.zshrc` - exists but not symlinked (will be added to stow)
- `~/.dotfiles/git-aliases.zsh` - standalone file not sourced

### Backup Directories (from omarchy overrides)
- `~/.config/hypr.om` - Original omarchy hypr config
- `~/.config/waybar.om` - Original omarchy waybar config
- `~/.config/nvim.om` - Original omarchy nvim config

## Migration Strategy

### Phase 1: Remove existing symlinks
All existing symlinks will be removed before stow creates new ones.

### Phase 2: Restructure to stow packages
Each application will become a stow package with the following structure:
```
package-name/
└── .config/
    └── app-name/
        └── config files...
```

### Phase 3: Deploy with stow
Run `stow package-name` from ~/.dotfiles/ to create new symlinks.

## Post-Migration Verification Checklist
- [ ] All configs still work
- [ ] Omarchy overrides still intact
- [ ] ZSH loads properly
- [ ] All applications find their configs
- [ ] Custom scripts accessible in PATH
