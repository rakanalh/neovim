local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- nvim-cmp highlights
  hl(0, "CmpItemAbbr", { fg = colors.text })
  hl(0, "CmpItemAbbrDeprecated", { fg = colors.surface2, strikethrough = true })
  hl(0, "CmpItemAbbrMatch", { fg = colors.blue, bold = true })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = colors.blue, bold = true })

  -- Kind highlights
  hl(0, "CmpItemKind", { fg = colors.overlay0 })
  hl(0, "CmpItemKindClass", { fg = colors.yellow })
  hl(0, "CmpItemKindColor", { fg = colors.green })
  hl(0, "CmpItemKindConstant", { fg = colors.orange })
  hl(0, "CmpItemKindConstructor", { fg = colors.yellow })
  hl(0, "CmpItemKindEnum", { fg = colors.yellow })
  hl(0, "CmpItemKindEnumMember", { fg = colors.orange })
  hl(0, "CmpItemKindEvent", { fg = colors.violet })
  hl(0, "CmpItemKindField", { fg = colors.red })
  hl(0, "CmpItemKindFile", { fg = colors.blue })
  hl(0, "CmpItemKindFolder", { fg = colors.blue })
  hl(0, "CmpItemKindFunction", { fg = colors.blue })
  hl(0, "CmpItemKindInterface", { fg = colors.yellow })
  hl(0, "CmpItemKindKeyword", { fg = colors.violet })
  hl(0, "CmpItemKindMethod", { fg = colors.blue })
  hl(0, "CmpItemKindModule", { fg = colors.yellow })
  hl(0, "CmpItemKindOperator", { fg = colors.text })
  hl(0, "CmpItemKindProperty", { fg = colors.red })
  hl(0, "CmpItemKindReference", { fg = colors.red })
  hl(0, "CmpItemKindSnippet", { fg = colors.green })
  hl(0, "CmpItemKindStruct", { fg = colors.yellow })
  hl(0, "CmpItemKindText", { fg = colors.text })
  hl(0, "CmpItemKindTypeParameter", { fg = colors.red })
  hl(0, "CmpItemKindUnit", { fg = colors.orange })
  hl(0, "CmpItemKindValue", { fg = colors.orange })
  hl(0, "CmpItemKindVariable", { fg = colors.red })

  -- Menu highlights
  hl(0, "CmpItemMenu", { fg = colors.subtext1 })

  -- Documentation window
  hl(0, "CmpDocumentation", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.surface0 })
  hl(0, "CmpDocumentationBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.surface0 })

  -- Selection
  hl(0, "PmenuSel", { bg = colors.surface1, bold = true })
  hl(0, "Pmenu", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.surface0 })
  hl(0, "PmenuBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.surface0 })

  -- Scrollbar
  hl(0, "PmenuSbar", { bg = colors.surface1 })
  hl(0, "PmenuThumb", { bg = colors.overlay0 })
end

return M