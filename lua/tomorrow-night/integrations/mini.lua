local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- mini.indentscope
  hl(0, "MiniIndentscopeSymbol", { fg = colors.blue })
  hl(0, "MiniIndentscopePrefix", { nocombine = true })

  -- mini.jump
  hl(0, "MiniJump", { fg = colors.base, bg = colors.violet })

  -- mini.jump2d
  hl(0, "MiniJump2dSpot", { fg = colors.orange, bold = true, nocombine = true })
  hl(0, "MiniJump2dSpotAhead", { fg = colors.base, bg = colors.blue, nocombine = true })
  hl(0, "MiniJump2dSpotUnique", { fg = colors.orange, bold = true, nocombine = true })
  hl(0, "MiniJump2dDim", { fg = colors.surface2 })

  -- mini.starter
  hl(0, "MiniStarterCurrent", { nocombine = true })
  hl(0, "MiniStarterFooter", { fg = colors.violet, italic = true })
  hl(0, "MiniStarterHeader", { fg = colors.blue })
  hl(0, "MiniStarterInactive", { fg = colors.subtext1 })
  hl(0, "MiniStarterItem", { bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "MiniStarterItemBullet", { fg = colors.blue })
  hl(0, "MiniStarterItemPrefix", { fg = colors.yellow })
  hl(0, "MiniStarterSection", { fg = colors.violet })
  hl(0, "MiniStarterQuery", { fg = colors.green })

  -- mini.statusline
  hl(0, "MiniStatuslineDevinfo", { fg = colors.subtext1, bg = colors.surface0 })
  hl(0, "MiniStatuslineFileinfo", { fg = colors.subtext1, bg = colors.surface0 })
  hl(0, "MiniStatuslineFilename", { fg = colors.text, bg = colors.mantle })
  hl(0, "MiniStatuslineInactive", { fg = colors.blue, bg = colors.mantle })
  hl(0, "MiniStatuslineModeCommand", { fg = colors.base, bg = colors.violet, bold = true })
  hl(0, "MiniStatuslineModeInsert", { fg = colors.base, bg = colors.green, bold = true })
  hl(0, "MiniStatuslineModeNormal", { fg = colors.mantle, bg = colors.blue, bold = true })
  hl(0, "MiniStatuslineModeOther", { fg = colors.base, bg = colors.cyan, bold = true })
  hl(0, "MiniStatuslineModeReplace", { fg = colors.base, bg = colors.red, bold = true })
  hl(0, "MiniStatuslineModeVisual", { fg = colors.base, bg = colors.yellow, bold = true })

  -- mini.surround
  hl(0, "MiniSurround", { link = "IncSearch" })

  -- mini.tabline
  hl(0, "MiniTablineCurrent", { fg = colors.text, bg = colors.surface0, bold = true })
  hl(0, "MiniTablineFill", { bg = colors.mantle })
  hl(0, "MiniTablineHidden", { fg = colors.subtext1, bg = colors.mantle })
  hl(0, "MiniTablineModifiedCurrent", { fg = colors.blue, bg = colors.surface0, bold = true })
  hl(0, "MiniTablineModifiedHidden", { fg = colors.blue, bg = colors.mantle })
  hl(0, "MiniTablineModifiedVisible", { fg = colors.blue, bg = colors.surface0 })
  hl(0, "MiniTablineTabpagesection", { fg = colors.base, bg = colors.violet, bold = true })
  hl(0, "MiniTablineVisible", { fg = colors.text, bg = colors.surface0 })

  -- mini.test
  hl(0, "MiniTestEmphasis", { bold = true })
  hl(0, "MiniTestFail", { fg = colors.red, bold = true })
  hl(0, "MiniTestPass", { fg = colors.green, bold = true })

  -- mini.trailspace
  hl(0, "MiniTrailspace", { bg = colors.red })
end

return M