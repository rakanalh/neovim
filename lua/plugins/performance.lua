-- Performance optimizations for faster startup and runtime
return {
  -- Impatient.nvim for faster startup via module caching
  {
    "lewis6991/impatient.nvim",
    priority = 10000, -- Load this first
    config = function()
      require("impatient").enable_profile()
    end,
  },

  -- Disable some built-in plugins for performance
  {
    "vim-startup-optimizer",
    name = "vim-startup-optimizer",
    dir = vim.fn.stdpath("config"),
    priority = 9999,
    config = function()
      -- Disable unused built-in plugins
      local disabled_built_ins = {
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "gzip",
        "zip",
        "zipPlugin",
        "tar",
        "tarPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "matchit",
        "matchparen",
        "tohtml",
        "tutor",
      }

      for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
      end

      -- Performance optimizations
      vim.opt.updatetime = 100 -- Faster completion
      vim.opt.redrawtime = 1500 -- Allow more time before timing out
      vim.opt.ttimeoutlen = 10 -- Faster key response
      vim.opt.synmaxcol = 240 -- Don't syntax highlight long lines

      -- Disable some providers we don't use
      vim.g.loaded_python3_provider = 0
      vim.g.loaded_ruby_provider = 0
      vim.g.loaded_perl_provider = 0
      vim.g.loaded_node_provider = 0

      -- Defer shada (session data) writing
      vim.opt.shadafile = "NONE"
      vim.api.nvim_create_autocmd("CmdlineLeave", {
        pattern = "*",
        once = true,
        callback = function()
          vim.opt.shadafile = ""
          vim.cmd("silent! rshada!")
        end,
      })
    end,
  },
}