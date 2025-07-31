return {
  -- Extend the existing phpactor configuration from LazyVim PHP extras
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {
          init_options = {
            ["language_server_worse_reflection.inlay_hints.enable"] = false,
            ["language_server_worse_reflection.inlay_hints.params"] = false,
            ["language_server_worse_reflection.inlay_hints.types"] = false,
            ["language_server_configuration.auto_config"] = false,
            ["code_transform.import_globals"] = true,
            ["language_server_phpstan.enabled"] = false,
            ["language_server_psalm.enabled"] = false,
            ["language_server_php_cs_fixer.enabled"] = false,
            -- Ignore docblock-related diagnostic codes
            ["language_server.diagnostic_ignore_codes"] = {
              "missing_param",
              "missing_return",
              "missing_method",
              "missing_property",
            },
          },
        },
      },
    },
  },
}