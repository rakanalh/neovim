local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- indent-blankline highlights
  hl(0, "IblIndent", { fg = colors.surface0 })
  hl(0, "IblScope", { fg = colors.blue })

  -- Legacy support for older versions
  hl(0, "IndentBlanklineChar", { fg = colors.surface0 })
  hl(0, "IndentBlanklineContextChar", { fg = colors.blue })
  hl(0, "IndentBlanklineContextStart", { sp = colors.blue, underline = true })
  hl(0, "IndentBlanklineSpaceChar", { fg = colors.surface0 })
  hl(0, "IndentBlanklineSpaceCharBlankline", { fg = colors.surface0 })

  -- Rainbow indent levels if enabled
  if opts.integrations.indent_blankline.colored_indent_levels then
    hl(0, "IblIndent1", { fg = colors.red })
    hl(0, "IblIndent2", { fg = colors.yellow })
    hl(0, "IblIndent3", { fg = colors.green })
    hl(0, "IblIndent4", { fg = colors.cyan })
    hl(0, "IblIndent5", { fg = colors.blue })
    hl(0, "IblIndent6", { fg = colors.violet })
  end
end

return M