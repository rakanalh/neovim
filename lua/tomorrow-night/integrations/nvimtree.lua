local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- NvimTree highlights
  hl(0, "NvimTreeNormal", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "NvimTreeNormalNC", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "NvimTreeWinSeparator", { fg = colors.surface0, bg = opts.transparent_background and "NONE" or colors.base })

  -- Files
  hl(0, "NvimTreeRootFolder", { fg = colors.orange, bold = true })
  hl(0, "NvimTreeFolderIcon", { fg = colors.blue })
  hl(0, "NvimTreeFolderName", { fg = colors.blue })
  hl(0, "NvimTreeOpenedFolderName", { fg = colors.blue, bold = true })
  hl(0, "NvimTreeEmptyFolderName", { fg = colors.blue })
  hl(0, "NvimTreeSymlink", { fg = colors.cyan })
  hl(0, "NvimTreeExecFile", { fg = colors.green, bold = true })
  hl(0, "NvimTreeImageFile", { fg = colors.violet })
  hl(0, "NvimTreeSpecialFile", { fg = colors.yellow })

  -- Git - All filenames in white, only icons/indicators colored
  hl(0, "NvimTreeGitDirty", { fg = colors.text })
  hl(0, "NvimTreeGitNew", { fg = colors.text })
  hl(0, "NvimTreeGitDeleted", { fg = colors.text })
  hl(0, "NvimTreeGitStaged", { fg = colors.text })
  hl(0, "NvimTreeGitMerge", { fg = colors.text })
  hl(0, "NvimTreeGitRenamed", { fg = colors.text })
  hl(0, "NvimTreeGitIgnored", { fg = colors.surface2 })

  -- UI elements
  hl(0, "NvimTreeIndentMarker", { fg = colors.surface1 })
  hl(0, "NvimTreeCursorLine", { bg = colors.surface0 })
  hl(0, "NvimTreeCursorLineNr", { fg = colors.blue })
  hl(0, "NvimTreeLineNr", { fg = colors.surface1 })
  hl(0, "NvimTreeStatusline", { fg = colors.text, bg = colors.mantle })
  hl(0, "NvimTreeStatuslineNC", { fg = colors.text, bg = colors.mantle })

  -- Bookmarks & Diagnostics
  hl(0, "NvimTreeBookmark", { fg = colors.violet })
  hl(0, "NvimTreeLspDiagnosticsError", { fg = colors.red })
  hl(0, "NvimTreeLspDiagnosticsWarning", { fg = colors.yellow })
  hl(0, "NvimTreeLspDiagnosticsInformation", { fg = colors.blue })
  hl(0, "NvimTreeLspDiagnosticsHint", { fg = colors.cyan })
end

return M