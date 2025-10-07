-- Productivity plugins for enhanced workflow
return {
  -- Snacks.nvim - Collection of useful utilities
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Disable animations for all snacks features
      animate = {
        enabled = false,
      },
      bigfile = {
        enabled = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        -- No animations
        style = "compact",
      },
      quickfile = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = {
          open = false,
          git_hl = false,
        },
      },
      words = {
        enabled = true,
        debounce = 200, -- Delay for highlighting
      },
      dashboard = {
        enabled = false, -- We're using dashboard-nvim
      },
    },
    keys = {
      { "<leader>ss", function() require("snacks").picker.lines() end,       desc = "Buffer Lines" },
      { "<leader>si", function() require("snacks").picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>bd", function() require("snacks").bufdelete() end,          desc = "Delete Buffer" },
      { "<leader>gb", function() require("snacks").git.blame_line() end,     desc = "Git Blame Line" },
      { "<leader>cR", function() require("snacks").rename() end,             desc = "Rename File" },
    },
  },

  -- Mini.ai - Better text objects
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" }, -- digits
          e = {                -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),                           -- function call
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- function call with underscore
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      require("lazyvim.util").on_load("which-key.nvim", function()
        vim.schedule(function()
          require("lazyvim.util.mini").ai_whichkey(opts)
        end)
      end)
    end,
  },

  -- Persistence.nvim - Better session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
      save_empty = false,
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },

  -- Yanky.nvim - Better yank/paste management
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") },
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = {
        on_put = false,  -- No animation on paste
        on_yank = false, -- No animation on yank
        timer = 200,
      },
      preserve_cursor_position = { enabled = true },
      ring = {
        history_length = 100,
        storage = jit.os:find("Windows") and "shada" or "sqlite",
        sync_with_numbered_registers = true,
        cancel_event = "update",
      },
      system_clipboard = {
        sync_with_ring = true,
      },
    },
    keys = {
      { "<leader>p", function() require("telescope").extensions.yank_history.yank_history() end, desc = "Open Yank History" },
      { "y",         "<Plug>(YankyYank)",                                                        mode = { "n", "x" },                           desc = "Yank Text" },
      { "p",         "<Plug>(YankyPutAfter)",                                                    mode = { "n", "x" },                           desc = "Put Yanked Text After Cursor" },
      { "P",         "<Plug>(YankyPutBefore)",                                                   mode = { "n", "x" },                           desc = "Put Yanked Text Before Cursor" },
      { "gp",        "<Plug>(YankyGPutAfter)",                                                   mode = { "n", "x" },                           desc = "Put Yanked Text After Selection" },
      { "gP",        "<Plug>(YankyGPutBefore)",                                                  mode = { "n", "x" },                           desc = "Put Yanked Text Before Selection" },
      { "[y",        "<Plug>(YankyCycleForward)",                                                desc = "Cycle Forward Through Yank History" },
      { "]y",        "<Plug>(YankyCycleBackward)",                                               desc = "Cycle Backward Through Yank History" },
      { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",                                      desc = "Put Indented After Cursor (Linewise)" },
      { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",                                     desc = "Put Indented Before Cursor (Linewise)" },
      { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",                                      desc = "Put Indented After Cursor (Linewise)" },
      { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",                                     desc = "Put Indented Before Cursor (Linewise)" },
      { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",                                    desc = "Put and Indent Right" },
      { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",                                     desc = "Put and Indent Left" },
      { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)",                                   desc = "Put Before and Indent Right" },
      { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",                                    desc = "Put Before and Indent Left" },
      { "=p",        "<Plug>(YankyPutAfterFilter)",                                              desc = "Put After Applying a Filter" },
      { "=P",        "<Plug>(YankyPutBeforeFilter)",                                             desc = "Put Before Applying a Filter" },
    },
  },

  -- Trouble.nvim v3 - Better diagnostics
  {
    "folke/trouble.nvim",
    branch = "main", -- Use v3
    cmd = { "Trouble" },
    opts = {
      modes = {
        cascade = {
          mode = "diagnostics", -- Start with diagnostics
          filter = function(items)
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item)
              return item.severity == severity
            end, items)
          end,
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                                       desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                          desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                               desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",                desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                                           desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                                            desc = "Quickfix List (Trouble)" },
      { "[x",         function() require("trouble").prev({ skip_groups = true, jump = true }) end, desc = "Previous Trouble Item" },
      { "]x",         function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "Next Trouble Item" },
    },
  },

  -- vim-illuminate - Highlight word under cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 100, -- Fast highlight
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      -- No animation, instant highlight
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "neo-tree",
        "lazy",
        "Trouble",
        "trouble",
        "dashboard",
        "help",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
}
