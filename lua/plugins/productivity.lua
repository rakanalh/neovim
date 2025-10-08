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
      picker = {
        enabled = true,
        layout = "bottom", -- Use bottom layout (ivy preset at bottom)
        -- Enable frecency scoring for recently/frequently used files
        matcher = {
          frecency = true, -- Score files based on frequency and recency of use
        },
        -- Optional: Enable debug scores to see frecency values (disable in production)
        -- debug = {
        --   scores = true,
        -- },
        -- Configure picker sources
        sources = {
          buffers = {
            format = "file",
            hidden = false,
          },
          files = {
            hidden = false,
            ignored = false,
          },
          grep = {
            hidden = true,
          },
        },
      },
    },
    keys = {
      -- Project management
      {
        "<leader>pp",
        function()
          require("snacks").picker.projects({
            confirm = function(picker, item)
              if not item then return end
              picker:close()

              local project_path = vim.fn.fnamemodify(item.file, ":p"):gsub("/$", "")

              -- Check if this project is already open in a tab
              local tabs = vim.api.nvim_list_tabpages()
              local existing_tab = nil
              local has_project_tabs = false

              for _, tab in ipairs(tabs) do
                local ok, tab_project = pcall(vim.api.nvim_tabpage_get_var, tab, "project_path")
                if ok and tab_project then
                  has_project_tabs = true
                  local normalized_tab_path = vim.fn.fnamemodify(tab_project, ":p"):gsub("/$", "")
                  if normalized_tab_path == project_path then
                    existing_tab = tab
                    break
                  end
                end
              end

              if existing_tab then
                -- Switch to existing project tab
                vim.api.nvim_set_current_tabpage(existing_tab)
              else
                -- If no project tabs exist yet, replace current tab (dashboard)
                -- Otherwise create new tab
                if not has_project_tabs then
                  vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
                  vim.api.nvim_tabpage_set_var(0, "project_path", project_path)
                else
                  vim.cmd("$tabnew")
                  vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
                  vim.api.nvim_tabpage_set_var(0, "project_path", project_path)
                end
                -- Open file picker
                vim.schedule(function()
                  require("snacks").picker.files()
                end)
              end
            end,
          })
        end,
        desc = "Switch Project (New Tab)"
      },
      {
        "<leader>pP",
        function()
          require("snacks").picker.projects({
            confirm = function(picker, item)
              if not item then return end
              picker:close()
              vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
              vim.schedule(function()
                require("snacks").picker.files()
              end)
            end,
          })
        end,
        desc = "Open Project in Current Tab"
      },

      -- File finding
      { "<leader>pf", function() require("snacks").picker.files() end,                                 desc = "Find File in Project" },
      { "<leader>ps", function() require("snacks").picker.grep() end,                                  desc = "Search in Project" },
      { "<leader>pb", function() require("snacks").picker.buffers() end,                               desc = "Project Buffers" },
      { "<leader>pr", function() require("snacks").picker.recent() end,                                desc = "Recent Project Files" },
      { "<leader>p.", function() require("snacks").picker.files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find File in Current Directory" },

      -- Recent files
      { "<leader>fr", function() require("snacks").picker.recent() end,                                desc = "Recent Files" },
      { "<leader>fR", function() require("snacks").picker.recent({ cwd = vim.uv.cwd() }) end,          desc = "Recent Files in CWD" },

      -- Buffer management
      { "<leader>b,", function() require("snacks").picker.buffers() end,                               desc = "Tab Buffers" },

      -- Git integration
      { "<leader>gc", function() require("snacks").picker.git_log() end,                               desc = "Git Commits" },
      { "<leader>gb", function() require("snacks").picker.git_branches() end,                          desc = "Git Branches" },
      { "<leader>gs", function() require("snacks").picker.git_status() end,                            desc = "Git Status" },

      -- Search
      { "<leader>sp", function() require("snacks").picker.grep() end,                                  desc = "Grep (Search in Project)",      mode = "n" },
      {
        "<leader>sp",
        mode = "v",
        function()
          -- Get visual selection
          vim.cmd('noau normal! "vy"')
          local text = vim.fn.getreg('v')
          vim.fn.setreg('v', {})
          require("snacks").picker.grep({ search = text })
        end,
        desc = "Grep Selection"
      },
      { "<leader>*",       function() require("snacks").picker.grep_word() end,                      desc = "Search Word in Project" },
      { "<leader>sw",      function() require("snacks").picker.grep_word() end,                      desc = "Word" },
      { "<leader>sW",      function() require("snacks").picker.grep_word({ word_match = true }) end, desc = "Word (exact)" },
      { "<leader>sC",      function() require("snacks").picker.commands() end,                       desc = "Commands" },
      { "<leader>sk",      function() require("snacks").picker.keymaps() end,                        desc = "Key Maps" },
      { "<leader>sh",      function() require("snacks").picker.help() end,                           desc = "Help Pages" },
      { "<leader>sM",      function() require("snacks").picker.man() end,                            desc = "Man Pages" },
      { "<leader>sm",      function() require("snacks").picker.marks() end,                          desc = "Jump to Mark" },
      { "<leader>sR",      function() require("snacks").picker.resume() end,                         desc = "Resume" },
      { "<leader>sd",      function() require("snacks").picker.diagnostics_buffer() end,             desc = "Document Diagnostics" },
      { "<leader>sD",      function() require("snacks").picker.diagnostics() end,                    desc = "Workspace Diagnostics" },
      { "<leader>ss",      function() require("snacks").picker.lines() end,                          desc = "Search Buffer" },
      { "<leader>si",      function() require("snacks").picker.lsp_symbols() end,                    desc = "LSP Symbols" },

      -- LSP
      { "gd",              function() require("snacks").picker.lsp_definitions() end,                desc = "Goto Definition" },
      { "gr",              function() require("snacks").picker.lsp_references() end,                 desc = "References" },
      { "gI",              function() require("snacks").picker.lsp_implementations() end,            desc = "Goto Implementation" },
      { "gy",              function() require("snacks").picker.lsp_type_definitions() end,           desc = "Goto Type Definition" },
      { "<leader>sS",      function() require("snacks").picker.lsp_workspace_symbols() end,          desc = "Goto Symbol (Workspace)" },

      -- Additional keybindings
      { "<leader><space>", function() require("snacks").picker.smart() end,                          desc = "Smart Find Files" },
      { "<leader>bd",      function() require("snacks").bufdelete() end,                             desc = "Delete Buffer" },
      { "<leader>cR",      function() require("snacks").rename() end,                                desc = "Rename File" },

      -- Session picker using auto-session
      {
        "<leader>ql",
        function()
          local sessions = require("auto-session.lib").get_session_files()
          local items = {}
          for _, session in ipairs(sessions) do
            table.insert(items, {
              file = session,
              text = vim.fn.fnamemodify(session, ":t:r"),
            })
          end

          require("snacks").picker.pick({
            source = {
              name = "sessions",
              get = function()
                return items
              end
            },
            format = "text",
            preview = false,
            confirm = function(picker, item)
              if not item then return end
              picker:close()
              vim.schedule(function()
                require("auto-session").RestoreSessionFile(item.file)
              end)
            end,
          })
        end,
        desc = "List Sessions"
      },
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
      { "<leader>p", function() require("snacks").picker.registers() end, desc = "Open Yank History" },
      { "y",         "<Plug>(YankyYank)",                                 mode = { "n", "x" },                           desc = "Yank Text" },
      { "p",         "<Plug>(YankyPutAfter)",                             mode = { "n", "x" },                           desc = "Put Yanked Text After Cursor" },
      { "P",         "<Plug>(YankyPutBefore)",                            mode = { "n", "x" },                           desc = "Put Yanked Text Before Cursor" },
      { "gp",        "<Plug>(YankyGPutAfter)",                            mode = { "n", "x" },                           desc = "Put Yanked Text After Selection" },
      { "gP",        "<Plug>(YankyGPutBefore)",                           mode = { "n", "x" },                           desc = "Put Yanked Text Before Selection" },
      { "[y",        "<Plug>(YankyCycleForward)",                         desc = "Cycle Forward Through Yank History" },
      { "]y",        "<Plug>(YankyCycleBackward)",                        desc = "Cycle Backward Through Yank History" },
      { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",               desc = "Put Indented After Cursor (Linewise)" },
      { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",              desc = "Put Indented Before Cursor (Linewise)" },
      { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",               desc = "Put Indented After Cursor (Linewise)" },
      { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",              desc = "Put Indented Before Cursor (Linewise)" },
      { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",             desc = "Put and Indent Right" },
      { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",              desc = "Put and Indent Left" },
      { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)",            desc = "Put Before and Indent Right" },
      { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",             desc = "Put Before and Indent Left" },
      { "=p",        "<Plug>(YankyPutAfterFilter)",                       desc = "Put After Applying a Filter" },
      { "=P",        "<Plug>(YankyPutBeforeFilter)",                      desc = "Put Before Applying a Filter" },
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
