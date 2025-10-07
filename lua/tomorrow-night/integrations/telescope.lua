local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Telescope highlights
  hl(0, "TelescopeBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "TelescopeNormal", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "TelescopePreviewNormal", { link = "TelescopeNormal" })
  hl(0, "TelescopePromptNormal", { link = "TelescopeNormal" })
  hl(0, "TelescopeResultsNormal", { link = "TelescopeNormal" })
  hl(0, "TelescopeTitle", { fg = colors.subtext0, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "TelescopeSelectionCaret", { fg = colors.orange, bg = colors.surface0 })
  hl(0, "TelescopeSelection", { fg = colors.text, bg = colors.surface0, bold = true })
  hl(0, "TelescopeMatching", { fg = colors.blue })
  hl(0, "TelescopePromptPrefix", { fg = colors.orange })

  -- Telescope specific titles
  hl(0, "TelescopePreviewTitle", { fg = colors.base, bg = colors.green })
  hl(0, "TelescopePromptTitle", { fg = colors.base, bg = colors.red })
  hl(0, "TelescopeResultsTitle", { fg = colors.base, bg = colors.violet })

  -- Telescope prompt
  hl(0, "TelescopePromptBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "TelescopePromptCounter", { fg = colors.subtext1 })

  -- Telescope preview
  hl(0, "TelescopePreviewBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "TelescopePreviewLine", { bg = colors.surface0 })
  hl(0, "TelescopePreviewMatch", { bg = colors.surface0 })

  -- Telescope results
  hl(0, "TelescopeResultsBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "TelescopeResultsLineNr", { fg = colors.surface1 })
  hl(0, "TelescopeResultsMethod", { fg = colors.blue })

  -- Multi-selection
  hl(0, "TelescopeMultiSelection", { fg = colors.violet, bold = true })
  hl(0, "TelescopeMultiIcon", { fg = colors.violet })
end

return M