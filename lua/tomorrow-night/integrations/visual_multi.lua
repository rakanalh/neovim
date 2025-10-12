local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Multi-cursor highlights with bright orange for high visibility
  -- VM_Cursor - Main cursor appearance in multi-cursor mode
  hl(0, "VM_Cursor", { fg = colors.base, bg = colors.orange, bold = true })

  -- VM_Extend - Extended selection appearance (visual mode)
  hl(0, "VM_Extend", { bg = colors.surface1 })

  -- VM_Insert - Insert mode cursor appearance
  hl(0, "VM_Insert", { fg = colors.base, bg = colors.orange, bold = true })

  -- VM_Mono - Single cursor operation appearance
  hl(0, "VM_Mono", { fg = colors.base, bg = colors.peach, italic = true })

  -- Additional VM highlights for better visibility
  hl(0, "VMCursor", { fg = colors.base, bg = colors.orange, bold = true })

  -- Selected text highlight (make it distinct from regular visual)
  hl(0, "VM_Selection", { bg = colors.surface1 })
end

return M
