local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Barbecue normal text
  hl(0, "barbecue_normal", { fg = colors.subtext1, bg = opts.transparent_background and "NONE" or colors.base })

  -- Ellipsis for truncated paths
  hl(0, "barbecue_ellipsis", { fg = colors.overlay0, bg = opts.transparent_background and "NONE" or colors.base })

  -- Separator between breadcrumb items
  hl(0, "barbecue_separator", { fg = colors.overlay0, bg = opts.transparent_background and "NONE" or colors.base })

  -- Modified indicator
  hl(0, "barbecue_modified", { fg = colors.orange, bg = opts.transparent_background and "NONE" or colors.base })

  -- Directory name
  hl(0, "barbecue_dirname", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base })

  -- File basename
  hl(0, "barbecue_basename", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base, bold = true })

  -- Context (from LSP symbols)
  hl(0, "barbecue_context", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })

  -- File icon
  hl(0, "barbecue_file_icon", { bg = opts.transparent_background and "NONE" or colors.base })

  -- Context icons (using kinds from LSP)
  hl(0, "barbecue_context_file", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_module", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_namespace", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_package", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_class", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_method", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_property", { fg = colors.red, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_field", { fg = colors.red, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_constructor", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_enum", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_interface", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_function", { fg = colors.blue, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_variable", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_constant", { fg = colors.orange, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_string", { fg = colors.green, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_number", { fg = colors.orange, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_boolean", { fg = colors.orange, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_array", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_object", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_key", { fg = colors.red, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_null", { fg = colors.orange, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_enum_member", { fg = colors.cyan, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_struct", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_event", { fg = colors.orange, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_operator", { fg = colors.text, bg = opts.transparent_background and "NONE" or colors.base })
  hl(0, "barbecue_context_type_parameter", { fg = colors.yellow, bg = opts.transparent_background and "NONE" or colors.base })
end

return M
