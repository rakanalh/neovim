local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Dashboard highlights
  hl(0, "DashboardHeader", { fg = colors.blue })
  hl(0, "DashboardFooter", { fg = colors.violet })
  hl(0, "DashboardDesc", { fg = colors.text })
  hl(0, "DashboardKey", { fg = colors.orange })
  hl(0, "DashboardIcon", { fg = colors.blue, bold = true })
  hl(0, "DashboardShortCut", { fg = colors.violet })

  -- Alpha (alternative dashboard)
  hl(0, "AlphaHeader", { fg = colors.blue })
  hl(0, "AlphaButtons", { fg = colors.text })
  hl(0, "AlphaShortcut", { fg = colors.orange })
  hl(0, "AlphaFooter", { fg = colors.violet })
end

return M