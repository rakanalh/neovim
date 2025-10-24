return {
  -- Better UI for notifications - Extend LazyVim's configuration
  {
    "folke/noice.nvim",
    opts = {
      -- LazyVim already sets lsp.override, just add custom views and presets
      presets = {
        inc_rename = true, -- Add inc_rename preset
      },
      -- Custom view positions
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
      -- Instant response
      throttle = 1000 / 60,
    },
    dependencies = {
      {
        "rcarriga/nvim-notify",
        opts = {
          -- Disable animations for instant notifications
          stages = "static",
          render = "default",
          fps = 1,
        },
      },
    },
  },

  -- Dashboard (disabled in favor of Obsidian daily note startup)
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },

  -- Status line - uses LazyVim's default configuration
  -- No customization needed, LazyVim's lualine works perfectly with tomorrow-night theme

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- Active indent guide and indent text objects
  {
    "nvim-mini/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Load Tomorrow Night theme
  {
    "tomorrow-night-theme",
    name = "tomorrow-night-theme",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      require("tomorrow-night").load()
    end,
  },

  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      handle = {
        color = "#3b4261",
      },
      marks = {
        Search = { color = "#ff9e64" },
        Error = { color = "#db4b4b" },
        Warn = { color = "#e0af68" },
        Info = { color = "#0db9d7" },
        Hint = { color = "#1abc9c" },
        Misc = { color = "#9d7cd8" },
      },
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
      },
      handlers = {
        diagnostic = true,
        search = false,
        gitsigns = false,
      },
    },
    config = function(_, opts)
      require("scrollbar").setup(opts)
      -- Override diagnostic handler to add buffer validation
      local diagnostic_handler = require("scrollbar.handlers.diagnostic")
      local original_show = diagnostic_handler.show
      diagnostic_handler.show = function(...)
        local ok = pcall(original_show, ...)
        if not ok then
          -- Silently ignore errors from invalid buffers
          return
        end
      end
    end,
  },

  -- Edgy.nvim - Window layout management
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      -- Recommended settings
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      options = {
        left = { size = 30 },
        right = { size = 30 },
      },
      left = {
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { width = 30 },
          pinned = true,
          open = "Neotree position=left filesystem",
        },
      },
      right = {
        {
          title = false,
          ft = "md-agenda",
          filter = function(buf)
            return vim.b[buf].md_agenda_type == "agenda"
          end,
          size = { width = 0.2 },
          pinned = true,
          open = function()
            vim.cmd("AgendaView")
          end,
        },
        {
          title = false,
          ft = "md-agenda",
          filter = function(buf)
            return vim.b[buf].md_agenda_type == "habit"
          end,
          size = { height = 0.5 },
          pinned = true,
          open = function()
            vim.cmd("HabitView")
          end,
        },
      },
    },
  },
}
