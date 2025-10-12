local M = {}

function M.apply()
  local config = require("tomorrow-night")
  local colors = config.palette
  local opts = config.options

  local function hl(group, props)
    vim.api.nvim_set_hl(0, group, props)
  end

  -- Utility function for styles
  local function apply_styles(base, styles)
    if not styles then
      return base
    end
    for _, style in ipairs(styles) do
      if style == "italic" then
        base.italic = true
      elseif style == "bold" then
        base.bold = true
      elseif style == "underline" then
        base.underline = true
      end
    end
    return base
  end

  -- Editor highlights
  hl("Normal", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl("NormalFloat", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl("NormalNC", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl("Cursor", { fg = colors.base, bg = colors.text })
  hl("CursorLine", { bg = colors.surface0 })
  hl("CursorLineNr", { fg = colors.blue })
  hl("CursorColumn", { bg = colors.surface0 })
  hl("ColorColumn", { bg = colors.surface0 })
  hl("LineNr", { fg = colors.surface1 })
  hl("EndOfBuffer", { fg = opts.show_end_of_buffer and colors.surface1 or colors.base })
  hl("SignColumn", { fg = colors.surface1, bg = opts.transparent_background and "NONE" or colors.base })
  hl("VertSplit", { fg = colors.surface0 })
  hl("WinSeparator", { fg = colors.surface0 })

  -- Folding
  hl("Folded", { fg = colors.blue, bg = colors.surface1 })
  hl("FoldColumn", { fg = colors.overlay0 })

  -- Search & Selection
  hl("Visual", { bg = colors.surface1 })
  hl("VisualNOS", { bg = colors.surface1 })
  hl("Search", { fg = colors.base, bg = colors.yellow })
  hl("IncSearch", { fg = colors.base, bg = colors.orange })
  hl("CurSearch", { fg = colors.base, bg = colors.red })
  hl("MatchParen", { fg = colors.peach, bg = colors.surface1, bold = true })

  -- Popup Menu
  hl("Pmenu", { fg = colors.text, bg = colors.surface0 })
  hl("PmenuSel", { fg = colors.text, bg = colors.surface1, bold = true })
  hl("PmenuSbar", { bg = colors.surface1 })
  hl("PmenuThumb", { bg = colors.overlay0 })

  -- Messages
  hl("ErrorMsg", { fg = colors.red, italic = true, bold = true })
  hl("WarningMsg", { fg = colors.yellow })
  hl("MoreMsg", { fg = colors.blue })
  hl("ModeMsg", { fg = colors.text, bold = true })
  hl("Question", { fg = colors.blue })

  -- Floating windows
  hl("FloatBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl("FloatTitle", { fg = colors.subtext0, bg = opts.transparent_background and "NONE" or colors.mantle })

  -- Statusline
  hl("StatusLine", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl("StatusLineNC", { fg = colors.surface1, bg = opts.transparent_background and "NONE" or colors.mantle })

  -- Tabline - Improved styling with better contrast and visual hierarchy
  hl("TabLine", { fg = colors.overlay1, bg = colors.mantle }) -- Inactive tabs with subtle background
  hl("TabLineFill", { bg = opts.transparent_background and "NONE" or colors.crust }) -- Background fill
  hl("TabLineSel", { fg = colors.blue, bg = colors.surface0, bold = true }) -- Active tab with blue text for distinction

  -- Additional tabline groups for better customization
  hl("TabLineSeparator", { fg = colors.surface1, bg = colors.crust }) -- Tab separators
  hl("TabLineModified", { fg = colors.orange }) -- Modified indicator in orange

  -- Non-text characters
  hl("NonText", { fg = colors.overlay0 })
  hl("SpecialKey", { fg = colors.overlay0 })
  hl("Whitespace", { fg = colors.surface1 })
  hl("Conceal", { fg = colors.overlay1 })

  -- Directory
  hl("Directory", { fg = colors.blue })

  -- Title
  hl("Title", { fg = colors.blue, bold = true })

  -- Diff
  hl("DiffAdd", { fg = colors.green, bg = colors.surface0 })
  hl("DiffChange", { fg = colors.blue, bg = colors.surface0 }) -- Use blue for changes
  hl("DiffDelete", { fg = colors.red, bg = colors.surface0 })
  hl("DiffText", { fg = colors.blue, bg = colors.surface1, bold = true })

  -- Spell
  hl("SpellBad", { sp = colors.red, undercurl = true })
  hl("SpellCap", { sp = colors.yellow, undercurl = true })
  hl("SpellLocal", { sp = colors.blue, undercurl = true })
  hl("SpellRare", { sp = colors.green, undercurl = true })

  -- Syntax highlighting
  hl("Comment", apply_styles({ fg = colors.subtext1 }, opts.styles.comments))
  hl("Constant", { fg = colors.orange })
  hl("String", apply_styles({ fg = colors.green }, opts.styles.strings))
  hl("Character", { fg = colors.green })
  hl("Number", apply_styles({ fg = colors.orange }, opts.styles.numbers))
  hl("Boolean", apply_styles({ fg = colors.orange }, opts.styles.booleans))
  hl("Float", { fg = colors.orange })
  hl("Identifier", apply_styles({ fg = colors.red }, opts.styles.variables))
  hl("Function", apply_styles({ fg = colors.blue }, opts.styles.functions))
  hl("Statement", apply_styles({ fg = colors.violet }, opts.styles.keywords))
  hl("Conditional", apply_styles({ fg = colors.violet }, opts.styles.conditionals))
  hl("Repeat", apply_styles({ fg = colors.violet }, opts.styles.loops))
  hl("Label", { fg = colors.violet })
  hl("Operator", apply_styles({ fg = colors.text }, opts.styles.operators))
  hl("Keyword", apply_styles({ fg = colors.violet }, opts.styles.keywords))
  hl("Exception", { fg = colors.violet })
  hl("PreProc", { fg = colors.violet })
  hl("Include", { fg = colors.violet })
  hl("Define", { fg = colors.violet })
  hl("Macro", { fg = colors.violet })
  hl("PreCondit", { fg = colors.violet })
  hl("Type", apply_styles({ fg = colors.yellow }, opts.styles.types))
  hl("StorageClass", { fg = colors.yellow })
  hl("Structure", { fg = colors.yellow })
  hl("Typedef", { fg = colors.yellow })
  hl("Special", { fg = colors.cyan })
  hl("SpecialChar", { fg = colors.cyan })
  hl("Tag", { fg = colors.red })
  hl("Delimiter", { fg = colors.text })
  hl("SpecialComment", { fg = colors.subtext1 })
  hl("Debug", { fg = colors.orange })
  hl("Underlined", { underline = true })
  hl("Ignore", { fg = colors.surface1 })
  hl("Error", { fg = colors.red })
  hl("Todo", { fg = colors.base, bg = colors.yellow, bold = true })

  -- Load integrations
  if opts.integrations.treesitter then
    require("tomorrow-night.integrations.treesitter").apply(colors, opts)
  end
  if opts.integrations.lsp then
    require("tomorrow-night.integrations.lsp").apply(colors, opts)
  end
  if opts.integrations.telescope.enabled then
    require("tomorrow-night.integrations.telescope").apply(colors, opts)
  end
  if opts.integrations.gitsigns then
    require("tomorrow-night.integrations.gitsigns").apply(colors, opts)
  end
  if opts.integrations.cmp then
    require("tomorrow-night.integrations.cmp").apply(colors, opts)
  end
  if opts.integrations.dashboard then
    require("tomorrow-night.integrations.dashboard").apply(colors, opts)
  end
  if opts.integrations.nvimtree then
    require("tomorrow-night.integrations.nvimtree").apply(colors, opts)
  end
  if opts.integrations.neotree then
    require("tomorrow-night.integrations.neotree").apply(colors, opts)
  end
  if opts.integrations.neogit then
    -- Debug: print when loading neogit integration
    -- vim.notify("Loading Tomorrow Night Neogit integration", vim.log.levels.DEBUG)
    require("tomorrow-night.integrations.neogit").apply(colors, opts)
  end
  if opts.integrations.octo then
    require("tomorrow-night.integrations.octo").apply(colors, opts)
  end
  if opts.integrations.notify then
    require("tomorrow-night.integrations.notify").apply(colors, opts)
  end
  if opts.integrations.mini.enabled then
    require("tomorrow-night.integrations.mini").apply(colors, opts)
  end
  if opts.integrations.which_key then
    require("tomorrow-night.integrations.whichkey").apply(colors, opts)
  end
  if opts.integrations.indent_blankline.enabled then
    require("tomorrow-night.integrations.indent_blankline").apply(colors, opts)
  end
  if opts.integrations.rainbow_delimiters then
    require("tomorrow-night.integrations.rainbow_delimiters").apply(colors, opts)
  end
  if opts.integrations.treesitter_context then
    require("tomorrow-night.integrations.treesitter_context").apply(colors, opts)
  end
  if opts.integrations.barbecue then
    require("tomorrow-night.integrations.barbecue").apply(colors, opts)
  end
  if opts.integrations.snacks then
    require("tomorrow-night.integrations.snacks").apply(colors, opts)
  end
  if opts.integrations.obsidian then
    require("tomorrow-night.integrations.obsidian").apply(colors, opts)
  end
  if opts.integrations.render_markdown then
    require("tomorrow-night.integrations.render_markdown").apply(colors, opts)
  end
  if opts.integrations.visual_multi then
    require("tomorrow-night.integrations.visual_multi").apply(colors, opts)
  end
  if opts.integrations.md_agenda then
    require("tomorrow-night.integrations.md_agenda").apply(colors, opts)
  end

  -- Apply custom Git overrides (blue for changes)
  hl("GitSignsChange", { fg = colors.blue })
  hl("GitSignsChangeNr", { fg = colors.blue })
  hl("GitSignsChangeLn", { fg = colors.blue })

  -- Apply terminal colors if enabled
  if opts.term_colors then
    vim.g.terminal_color_0 = colors.surface1
    vim.g.terminal_color_8 = colors.surface2

    vim.g.terminal_color_1 = colors.red
    vim.g.terminal_color_9 = colors.red

    vim.g.terminal_color_2 = colors.green
    vim.g.terminal_color_10 = colors.green

    vim.g.terminal_color_3 = colors.yellow
    vim.g.terminal_color_11 = colors.yellow

    vim.g.terminal_color_4 = colors.blue
    vim.g.terminal_color_12 = colors.blue

    vim.g.terminal_color_5 = colors.violet
    vim.g.terminal_color_13 = colors.violet

    vim.g.terminal_color_6 = colors.cyan
    vim.g.terminal_color_14 = colors.cyan

    vim.g.terminal_color_7 = colors.text
    vim.g.terminal_color_15 = colors.text
  end
end

return M
