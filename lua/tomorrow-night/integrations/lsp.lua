local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- LSP References
  hl(0, "LspReferenceText", { bg = colors.surface0 })
  hl(0, "LspReferenceRead", { bg = colors.surface0 })
  hl(0, "LspReferenceWrite", { bg = colors.surface0 })

  -- LSP Diagnostics
  hl(0, "DiagnosticError", { fg = colors.red })
  hl(0, "DiagnosticWarn", { fg = colors.yellow })
  hl(0, "DiagnosticInfo", { fg = colors.blue })
  hl(0, "DiagnosticHint", { fg = colors.cyan })
  hl(0, "DiagnosticOk", { fg = colors.green })

  -- Virtual Text
  hl(0, "DiagnosticVirtualTextError", { fg = colors.red, bg = colors.surface0, italic = true })
  hl(0, "DiagnosticVirtualTextWarn", { fg = colors.yellow, bg = colors.surface0, italic = true })
  hl(0, "DiagnosticVirtualTextInfo", { fg = colors.blue, bg = colors.surface0, italic = true })
  hl(0, "DiagnosticVirtualTextHint", { fg = colors.cyan, bg = colors.surface0, italic = true })
  hl(0, "DiagnosticVirtualTextOk", { fg = colors.green, bg = colors.surface0, italic = true })

  -- Underline
  hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
  hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
  hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue })
  hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.cyan })
  hl(0, "DiagnosticUnderlineOk", { undercurl = true, sp = colors.green })

  -- Floating
  hl(0, "DiagnosticFloatingError", { fg = colors.red })
  hl(0, "DiagnosticFloatingWarn", { fg = colors.yellow })
  hl(0, "DiagnosticFloatingInfo", { fg = colors.blue })
  hl(0, "DiagnosticFloatingHint", { fg = colors.cyan })
  hl(0, "DiagnosticFloatingOk", { fg = colors.green })

  -- Sign column
  hl(0, "DiagnosticSignError", { fg = colors.red })
  hl(0, "DiagnosticSignWarn", { fg = colors.yellow })
  hl(0, "DiagnosticSignInfo", { fg = colors.blue })
  hl(0, "DiagnosticSignHint", { fg = colors.cyan })
  hl(0, "DiagnosticSignOk", { fg = colors.green })

  -- LSP Semantic Tokens
  hl(0, "@lsp.type.class", { link = "Type" })
  hl(0, "@lsp.type.comment", { link = "Comment" })
  hl(0, "@lsp.type.decorator", { link = "@attribute" })
  hl(0, "@lsp.type.enum", { link = "Type" })
  hl(0, "@lsp.type.enumMember", { link = "Constant" })
  hl(0, "@lsp.type.function", { link = "Function" })
  hl(0, "@lsp.type.interface", { link = "Type" })
  hl(0, "@lsp.type.keyword", { link = "Keyword" })
  hl(0, "@lsp.type.macro", { link = "Macro" })
  hl(0, "@lsp.type.method", { link = "Function" })
  hl(0, "@lsp.type.namespace", { link = "@namespace" })
  hl(0, "@lsp.type.number", { link = "Number" })
  hl(0, "@lsp.type.operator", { link = "Operator" })
  hl(0, "@lsp.type.parameter", { link = "@parameter" })
  hl(0, "@lsp.type.property", { link = "@property" })
  hl(0, "@lsp.type.regexp", { link = "String" })
  hl(0, "@lsp.type.string", { link = "String" })
  hl(0, "@lsp.type.struct", { link = "Type" })
  hl(0, "@lsp.type.type", { link = "Type" })
  hl(0, "@lsp.type.typeParameter", { link = "@parameter" })
  hl(0, "@lsp.type.variable", { link = "@variable" })

  -- LSP modifiers
  hl(0, "@lsp.mod.deprecated", { strikethrough = true })
  hl(0, "@lsp.mod.readonly", { italic = true })
  hl(0, "@lsp.mod.typeHint", { fg = colors.subtext1 })

  -- LSP Inlay Hints
  hl(0, "LspInlayHint", { fg = colors.surface2, bg = opts.transparent_background and "NONE" or colors.surface0 })
  hl(0, "LspCodeLens", { fg = colors.surface2 })
  hl(0, "LspCodeLensSeparator", { fg = colors.surface1 })

  -- LSP Signature
  hl(0, "LspSignatureActiveParameter", { bg = colors.surface0, bold = true })
end

return M