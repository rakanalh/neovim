local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- TreesitterContext - main context display
  -- Using mantle (darker background) to distinguish from regular code
  hl(0, "TreesitterContext", {
    fg = colors.text,
    bg = opts.transparent_background and colors.mantle or colors.mantle
  })

  -- TreesitterContextLineNumber - line numbers in the context
  hl(0, "TreesitterContextLineNumber", {
    fg = colors.blue,
    bg = opts.transparent_background and colors.mantle or colors.mantle
  })

  -- TreesitterContextBottom - separator line at the bottom of context
  -- Using surface1 for a subtle but visible separator
  hl(0, "TreesitterContextBottom", {
    fg = colors.surface1,
    bg = opts.transparent_background and colors.mantle or colors.mantle
  })

  -- TreesitterContextSeparator - alternative separator
  hl(0, "TreesitterContextSeparator", {
    fg = colors.surface1
  })
end

return M
