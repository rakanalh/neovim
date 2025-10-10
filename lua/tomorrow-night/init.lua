local M = {}

M.palette = require("tomorrow-night.palette")
M.options = {
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    telescope = {
      enabled = true,
    },
    which_key = true,
    dashboard = true,
    neotree = true,
    neogit = true,
    octo = true,
    lsp = true,
    markdown = true,
    treesitter_context = true,
    rainbow_delimiters = true,
    barbecue = true,
    snacks = true,
    obsidian = true,
    indent_blankline = {
      enabled = true,
      scope_color = "",
      colored_indent_levels = false,
    },
  },
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.load()
  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "tomorrow-night"

  local theme = require("tomorrow-night.theme")
  theme.apply()
end

return M