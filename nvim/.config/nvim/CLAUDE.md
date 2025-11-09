# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Configuration Structure

This is a LazyVim-based Neovim configuration optimized for PHP/Laravel and React/TypeScript development.

### Key Directories
- `lua/config/` - Core configuration (options, keymaps, lazy.lua)
- `lua/plugins/` - Plugin configurations
- `lazyvim.json` - LazyVim extras declaration

### Architecture Overview

The configuration uses LazyVim as a foundation with custom plugins and settings:
1. **Plugin Manager**: lazy.nvim with automatic updates
2. **LSP**: Intelephense for PHP, tsserver for TypeScript
3. **Formatting**: Pint/PHP-CS-Fixer for PHP (auto-detected), Prettier for JS/TS
4. **Theme**: Catppuccin Mocha with transparency

### Common Development Tasks

#### Adding a New Plugin
Create a new file in `lua/plugins/` that returns a plugin spec:
```lua
return {
  "plugin/name",
  config = function()
    -- configuration
  end,
}
```

#### Modifying LSP Settings
Edit `lua/plugins/webdev.lua` for PHP/web-related LSP configurations.

#### Adding Keymaps
Add custom keymaps to `lua/config/keymaps.lua` using the existing pattern.

### Important Notes

- PHP CodeSniffer is intentionally disabled in favor of phpactor diagnostics
- Formatting for PHP files automatically detects and uses Pint if available, otherwise PHP-CS-Fixer
- The configuration includes macOS-specific keybindings using the Option/Alt key
- REST API testing is available via kulala.nvim (files ending in .http)
- Database access is configured through vim-dadbod with UI

### WordPress Development

For WordPress development:

1. Install the stubs in your project:
```bash
# Required for WordPress functions
composer require --dev php-stubs/wordpress-stubs

# Optional: For WP-CLI commands development
composer require --dev php-stubs/wp-cli-stubs

# Optional: For WooCommerce development
composer require --dev php-stubs/woocommerce-stubs

# Optional: For ACF Pro development
composer require --dev php-stubs/acf-pro-stubs
```

2. Create a `.phpactor.json` file in your project root (see `.phpactor.json.example` for template):
```json
{
    "$schema": "https://raw.githubusercontent.com/phpactor/phpactor/master/phpactor.schema.json",
    "indexer.stub_paths": [
        "vendor/php-stubs/wordpress-stubs"
    ]
}
```

Phpactor will then provide autocompletion for WordPress functions.

### Code Style
All Lua files should be formatted with Stylua (2 spaces, 120 column width).