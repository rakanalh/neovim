local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- GitSigns highlights with yellow for changes
  hl(0, "GitSignsAdd", { fg = colors.green })
  hl(0, "GitSignsChange", { fg = colors.yellow })
  hl(0, "GitSignsDelete", { fg = colors.red })

  hl(0, "GitSignsCurrentLineBlame", { fg = colors.surface1 })

  if opts.transparent_background then
    hl(0, "GitSignsAddPreview", { fg = colors.green, bg = "NONE" })
    hl(0, "GitSignsDeletePreview", { fg = colors.red, bg = "NONE" })

    -- For word diff in previews
    hl(0, "GitSignsAddInline", { fg = colors.base, bg = colors.green, bold = true })
    hl(0, "GitSignsDeleteInline", { fg = colors.base, bg = colors.red, bold = true })
    hl(0, "GitSignsChangeInline", { fg = colors.base, bg = colors.orange, bold = true })

    hl(0, "GitSignsDeleteVirtLn", { fg = colors.red, bg = "NONE" })
  else
    hl(0, "GitSignsAddPreview", { link = "DiffAdd" })
    hl(0, "GitSignsDeletePreview", { link = "DiffDelete" })

    -- For word diff in previews
    hl(0, "GitSignsAddInline", { bg = colors.green, fg = colors.base })
    hl(0, "GitSignsChangeInline", { bg = colors.orange, fg = colors.base })
    hl(0, "GitSignsDeleteInline", { bg = colors.red, fg = colors.base })
  end

  -- Line number highlights
  hl(0, "GitSignsAddNr", { fg = colors.green })
  hl(0, "GitSignsChangeNr", { fg = colors.yellow })
  hl(0, "GitSignsDeleteNr", { fg = colors.red })

  -- Line highlights
  hl(0, "GitSignsAddLn", { bg = colors.surface0, fg = colors.green })
  hl(0, "GitSignsChangeLn", { bg = colors.surface0, fg = colors.yellow })
  hl(0, "GitSignsDeleteLn", { bg = colors.surface0, fg = colors.red })

  -- Statusline git colors
  hl(0, "StatusLineGitChange", { fg = colors.yellow })
end

return M