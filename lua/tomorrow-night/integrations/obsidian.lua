local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Obsidian highlights
  hl(0, "ObsidianTodo", { fg = colors.blue, bold = true })
  hl(0, "ObsidianDone", { fg = colors.green, bold = true })
  hl(0, "ObsidianRightArrow", { fg = colors.blue, bold = true })
  hl(0, "ObsidianTilde", { fg = colors.red, bold = true })
  hl(0, "ObsidianRefText", { fg = colors.violet, underline = true })
  hl(0, "ObsidianExtLinkIcon", { fg = colors.cyan })
  hl(0, "ObsidianTag", { fg = colors.blue, italic = true })
  hl(0, "ObsidianHighlightText", { bg = colors.yellow, fg = colors.base })
  hl(0, "ObsidianBullet", { fg = colors.blue, bold = true })
end

return M
