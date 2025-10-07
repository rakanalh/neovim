local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- which-key highlights
  hl(0, "WhichKey", { fg = colors.blue })
  hl(0, "WhichKeyGroup", { fg = colors.violet })
  hl(0, "WhichKeySeparator", { fg = colors.overlay0 })
  hl(0, "WhichKeyDesc", { fg = colors.text })
  hl(0, "WhichKeyValue", { fg = colors.text })

  hl(0, "WhichKeyFloat", { bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "WhichKeyBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
end

return M