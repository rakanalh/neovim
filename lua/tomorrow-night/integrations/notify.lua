local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- nvim-notify highlights
  hl(0, "NotifyERRORBorder", { fg = colors.red })
  hl(0, "NotifyERRORIcon", { fg = colors.red })
  hl(0, "NotifyERRORTitle", { fg = colors.red })
  hl(0, "NotifyERRORBody", { fg = colors.text })

  hl(0, "NotifyWARNBorder", { fg = colors.yellow })
  hl(0, "NotifyWARNIcon", { fg = colors.yellow })
  hl(0, "NotifyWARNTitle", { fg = colors.yellow })
  hl(0, "NotifyWARNBody", { fg = colors.text })

  hl(0, "NotifyINFOBorder", { fg = colors.blue })
  hl(0, "NotifyINFOIcon", { fg = colors.blue })
  hl(0, "NotifyINFOTitle", { fg = colors.blue })
  hl(0, "NotifyINFOBody", { fg = colors.text })

  hl(0, "NotifyDEBUGBorder", { fg = colors.cyan })
  hl(0, "NotifyDEBUGIcon", { fg = colors.cyan })
  hl(0, "NotifyDEBUGTitle", { fg = colors.cyan })
  hl(0, "NotifyDEBUGBody", { fg = colors.text })

  hl(0, "NotifyTRACEBorder", { fg = colors.violet })
  hl(0, "NotifyTRACEIcon", { fg = colors.violet })
  hl(0, "NotifyTRACETitle", { fg = colors.violet })
  hl(0, "NotifyTRACEBody", { fg = colors.text })

  hl(0, "NotifyBackground", { bg = colors.base })
end

return M