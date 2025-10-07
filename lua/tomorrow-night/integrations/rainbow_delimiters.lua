local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Rainbow Delimiters highlights
  hl(0, "RainbowDelimiterRed", { fg = colors.red })
  hl(0, "RainbowDelimiterYellow", { fg = colors.yellow })
  hl(0, "RainbowDelimiterGreen", { fg = colors.green })
  hl(0, "RainbowDelimiterCyan", { fg = colors.cyan })
  hl(0, "RainbowDelimiterBlue", { fg = colors.blue })
  hl(0, "RainbowDelimiterViolet", { fg = colors.violet })
  hl(0, "RainbowDelimiterOrange", { fg = colors.orange })

  -- Legacy ts-rainbow
  hl(0, "rainbowcol1", { fg = colors.red })
  hl(0, "rainbowcol2", { fg = colors.yellow })
  hl(0, "rainbowcol3", { fg = colors.green })
  hl(0, "rainbowcol4", { fg = colors.cyan })
  hl(0, "rainbowcol5", { fg = colors.blue })
  hl(0, "rainbowcol6", { fg = colors.violet })
  hl(0, "rainbowcol7", { fg = colors.orange })

  -- TSRainbow (nvim-treesitter rainbow)
  hl(0, "TSRainbowRed", { fg = colors.red })
  hl(0, "TSRainbowYellow", { fg = colors.yellow })
  hl(0, "TSRainbowGreen", { fg = colors.green })
  hl(0, "TSRainbowCyan", { fg = colors.cyan })
  hl(0, "TSRainbowBlue", { fg = colors.blue })
  hl(0, "TSRainbowViolet", { fg = colors.violet })
  hl(0, "TSRainbowOrange", { fg = colors.orange })
end

return M