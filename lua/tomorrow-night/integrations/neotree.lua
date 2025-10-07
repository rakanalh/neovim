local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Neo-tree highlights
  hl(0, "NeoTreeNormal", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "NeoTreeNormalNC", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "NeoTreeVertSplit", { fg = colors.surface0, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "NeoTreeWinSeparator", { fg = colors.surface0, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "NeoTreeEndOfBuffer", { fg = opts.show_end_of_buffer and colors.surface1 or colors.mantle })

  -- File/Folder
  hl(0, "NeoTreeRootName", { fg = colors.orange, bold = true })
  hl(0, "NeoTreeFileName", { fg = colors.text })
  hl(0, "NeoTreeFileNameOpened", { fg = colors.blue })
  hl(0, "NeoTreeFloatBorder", { link = "FloatBorder" })
  hl(0, "NeoTreeFloatTitle", { link = "FloatTitle" })
  hl(0, "NeoTreeTitleBar", { fg = colors.base, bg = colors.blue })

  hl(0, "NeoTreeFileIcon", { fg = colors.text })
  hl(0, "NeoTreeExpander", { fg = colors.surface2 })
  hl(0, "NeoTreeIndentMarker", { fg = colors.surface1 })

  -- Git status - Keep filenames white, only status indicators colored
  hl(0, "NeoTreeGitAdded", { fg = colors.text })
  hl(0, "NeoTreeGitConflict", { fg = colors.text })
  hl(0, "NeoTreeGitDeleted", { fg = colors.text })
  hl(0, "NeoTreeGitIgnored", { fg = colors.surface2 })
  hl(0, "NeoTreeGitModified", { fg = colors.text })
  hl(0, "NeoTreeGitRenamed", { fg = colors.text })
  hl(0, "NeoTreeGitStaged", { fg = colors.text })
  hl(0, "NeoTreeGitUnstaged", { fg = colors.text })
  hl(0, "NeoTreeGitUntracked", { fg = colors.text })

  hl(0, "NeoTreeDirectoryName", { fg = colors.blue })
  hl(0, "NeoTreeDirectoryIcon", { fg = colors.blue })
  hl(0, "NeoTreeSymbolicLinkTarget", { fg = colors.cyan })

  hl(0, "NeoTreeModified", { fg = colors.orange })
  hl(0, "NeoTreeCursorLine", { bg = colors.surface0 })

  -- Tabs
  hl(0, "NeoTreeTabInactive", { fg = colors.surface2, bg = colors.mantle })
  hl(0, "NeoTreeTabActive", { fg = colors.blue, bg = colors.surface0, bold = true })
  hl(0, "NeoTreeTabSeparatorInactive", { fg = colors.surface0, bg = colors.mantle })
  hl(0, "NeoTreeTabSeparatorActive", { fg = colors.surface0, bg = colors.surface0 })
end

return M