local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Picker main window
  hl(0, "SnacksPicker", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "SnacksPickerBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "SnacksPickerTitle", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base, bold = true })
  hl(0, "SnacksPickerFooter", { fg = colors.subtext0, bg = opts.transparent_background and "NONE" or colors.base })

  -- List window
  hl(0, "SnacksPickerList", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "SnacksPickerListBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "SnacksPickerListTitle", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base, bold = true })
  hl(0, "SnacksPickerListCursorLine", { bg = colors.surface0 })

  -- Input window
  hl(0, "SnacksPickerInput", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "SnacksPickerInputBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "SnacksPickerInputTitle", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle, bold = true })
  hl(0, "SnacksPickerInputSearch", { fg = colors.green, bold = true })
  hl(0, "SnacksPickerPrompt", { fg = colors.blue, bold = true })

  -- Preview window
  hl(0, "SnacksPickerPreview", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "SnacksPickerPreviewBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "SnacksPickerPreviewTitle", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base, bold = true })
  hl(0, "SnacksPickerPreviewCursorLine", { bg = colors.surface0 })
  hl(0, "SnacksPickerSearch", { fg = colors.base, bg = colors.yellow })

  -- File/Directory items - IMPORTANT: Make directory paths more visible
  hl(0, "SnacksPickerDir", { fg = colors.overlay1 })  -- Brighter than subtext1 for better visibility on CursorLine
  hl(0, "SnacksPickerFile", { fg = colors.text })
  hl(0, "SnacksPickerDirectory", { fg = colors.blue })
  hl(0, "SnacksPickerPathIgnored", { fg = colors.overlay0 })
  hl(0, "SnacksPickerPathHidden", { fg = colors.overlay0 })

  -- Delimiters and decorations
  hl(0, "SnacksPickerDelim", { fg = colors.surface2 })
  hl(0, "SnacksPickerRow", { fg = colors.cyan })
  hl(0, "SnacksPickerCol", { fg = colors.cyan })

  -- Matches
  hl(0, "SnacksPickerMatch", { fg = colors.yellow, bold = true })

  -- Status and info
  hl(0, "SnacksPickerSpinner", { fg = colors.blue })
  hl(0, "SnacksPickerTotals", { fg = colors.subtext0 })

  -- Toggles
  hl(0, "SnacksPickerToggleOn", { fg = colors.green, bold = true })
  hl(0, "SnacksPickerToggleOff", { fg = colors.surface2 })

  -- Markdown in picker
  hl(0, "SnacksPickerCode", { fg = colors.green })
  hl(0, "SnacksPickerBold", { bold = true })
  hl(0, "SnacksPickerItalic", { italic = true })

  -- Box window
  hl(0, "SnacksPickerBox", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "SnacksPickerBoxBorder", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle })
  hl(0, "SnacksPickerBoxTitle", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.mantle, bold = true })

  -- Pick windows
  hl(0, "SnacksPickerPickWin", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "SnacksPickerPickWinCurrent", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.surface0 })
end

return M
