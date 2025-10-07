# Tomorrow Night Theme for Neovim

A Neovim implementation of Chris Kempson's Tomorrow Night theme, following the catppuccin plugin structure.

## Features

- Full support for TreeSitter highlighting
- LSP semantic highlighting
- Extensive plugin integrations
- Customizable styles for syntax elements
- Git changes displayed in blue (instead of yellow/orange)
- Terminal colors support

## Usage

To activate the theme:
```vim
:lua require("tomorrow-night").load()
```

Or in your config:
```lua
vim.cmd.colorscheme("tomorrow-night")
```

## Theme Switching

Use `<leader>ut` to cycle through themes (carbonfox, onedark, catppuccin, tomorrow-night)

## Supported Plugins

- Telescope
- GitSigns (with blue for changes)
- Neogit (comprehensive Git UI support with blue for modifications)
- LSP & Diagnostics
- nvim-cmp
- Dashboard
- NvimTree & NeoTree
- Notify
- Mini modules
- Which-key
- Indent-blankline
- Rainbow delimiters
- Treesitter
- And more...

## Color Palette

Based on the original Tomorrow Night colors:
- Background: #1d1f21
- Foreground: #c5c8c6
- Red: #cc6666
- Orange: #de935f
- Yellow: #f0c674
- Green: #b5bd68
- Blue: #81a2be
- Violet: #b294bb
- Cyan: #8abeb7