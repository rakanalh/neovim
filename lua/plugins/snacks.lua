-- Snacks.nvim - Collection of useful utilities
return {
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
      scratch = {
        enabled = true,
        name = "Scratch",
        ft = function()
          if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
            return vim.bo.filetype
          end
          return "markdown"
        end,
        root = vim.fn.stdpath("data") .. "/scratch",
        autowrite = true,
        filekey = {
          cwd = true,
          branch = true,
          count = true,
        },
        win = { style = "scratch" },
        win_by_ft = {
          lua = {
            keys = {
              ["source"] = {
                "<cr>",
                function(self)
                  local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                  require("snacks").debug.run({ buf = self.buf, name = name })
                end,
                desc = "Source buffer",
                mode = { "n", "x" },
              },
            },
          },
        },
      },
      picker = {
        enabled = true,
        layout = {
          preset = "bottom",
          layout = {
            height = 0.3,
          },
        },
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
            hidden = true,
            ignored = false,
          },
          grep = {
            hidden = true,
          },
          projects = {
            -- Override to use project.nvim instead of directory search
            ---@param opts snacks.picker.projects.Config
            -- Custom format to bypass truncpath and show full ~ paths
            format = function(item, picker)
              local ret = {}
              -- Add folder icon
              if picker.opts.icons.files.enabled ~= false then
                local icon, hl = Snacks.util.icon("directory", "directory", {
                  fallback = picker.opts.icons.files,
                })
                icon = Snacks.picker.util.align(icon, picker.opts.formatters.file.icon_width or 2)
                ret[#ret + 1] = { icon, hl, virtual = true }
              end
              -- Use our pre-formatted display path (with ~)
              ret[#ret + 1] = { item.display or item.text, "SnacksPickerDirectory", field = "file" }
              return ret
            end,
            ---@type snacks.picker.finder
            finder = function(opts, ctx)
              -- Get home directory and check projects outside async context
              local home = vim.env.HOME or vim.fn.expand("~")
              local ok, project = pcall(require, "project")
              if not ok then
                return function(cb) end
              end

              local all_projects = project.get_recent_projects()
              if not all_projects or #all_projects == 0 then
                return function(cb) end
              end

              -- Filter to only existing directories and format paths
              local projects = {}
              for _, proj in ipairs(all_projects) do
                if vim.fn.isdirectory(proj) == 1 then
                  local display = proj
                  if proj:sub(1, #home) == home then
                    display = "~" .. proj:sub(#home + 1)
                  end
                  table.insert(projects, {
                    file = proj,
                    text = proj,  -- Keep full path for matching/selection
                    display = display,  -- What to show in picker
                    dir = true,
                  })
                end
              end

              ---@async
              ---@param cb async fun(item: snacks.picker.finder.Item)
              return function(cb)
                for _, item in ipairs(projects) do
                  cb(item)
                end
              end
            end,
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n" } },
              ["J"] = { "preview_scroll_down", mode = { "n" } },
              ["K"] = { "preview_scroll_up", mode = { "n" } },
              ["H"] = { "preview_scroll_left", mode = { "n" } },
              ["L"] = { "preview_scroll_right", mode = { "n" } },
            },
          },
        },
      },
    },
    keys = {

      -- Doom-like mappings
      {
        "<leader>,",
        function()
          require("snacks").picker.buffers()
        end,
        desc = "Switch Buffer",
      },
      {
        "<leader>.",
        function()
          require("snacks").picker.files()
        end,
        desc = "Find File",
      },
      {
        "<leader>'",
        function()
          require("snacks").picker.resume()
        end,
        desc = "Resume Last Picker",
      },

      -- File finding
      {
        "<leader>pf",
        function()
          require("snacks").picker.files()
        end,
        desc = "Find File in Project",
      },
      {
        "<leader>ps",
        function()
          require("snacks").picker.grep()
        end,
        desc = "Search in Project",
      },
      {
        "<leader>pb",
        function()
          require("snacks").picker.buffers()
        end,
        desc = "Project Buffers",
      },
      {
        "<leader>pr",
        function()
          require("snacks").picker.recent()
        end,
        desc = "Recent Project Files",
      },
      {
        "<leader>p.",
        function()
          require("snacks").picker.files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Find File in Current Directory",
      },

      -- Recent files
      {
        "<leader>fr",
        function()
          require("snacks").picker.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fR",
        function()
          require("snacks").picker.recent({ cwd = vim.uv.cwd() })
        end,
        desc = "Recent Files in CWD",
      },

      -- Buffer management
      {
        "<leader>b,",
        function()
          require("snacks").picker.buffers()
        end,
        desc = "Tab Buffers",
      },

      -- Git integration
      {
        "<leader>gc",
        function()
          require("snacks").picker.git_log()
        end,
        desc = "Git Commits",
      },
      {
        "<leader>gb",
        function()
          require("snacks").picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gs",
        function()
          require("snacks").picker.git_status()
        end,
        desc = "Git Status",
      },

      -- Search
      {
        "<leader>sd",
        function()
          require("snacks").picker.grep({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Grep (Search in Current Directory)",
        mode = "n",
      },
      { "<leader>sD", false, mode = "n" },
      { "<leader>sg", false, mode = "n" },
      { "<leader>sG", false, mode = "n" },
      {
        "<leader>sp",
        function()
          require("snacks").picker.grep()
        end,
        desc = "Grep (Search in Project)",
        mode = "n",
      },
      {
        "<leader>sp",
        mode = "v",
        function()
          -- Get visual selection
          vim.cmd('noau normal! "vy"')
          local text = vim.fn.getreg("v")
          vim.fn.setreg("v", {})
          require("snacks").picker.grep({ search = text })
        end,
        desc = "Grep Selection",
      },
      {
        "<leader>*",
        function()
          require("snacks").picker.grep_word()
        end,
        desc = "Search Word in Project",
      },
      {
        "<leader>sw",
        function()
          require("snacks").picker.grep_word()
        end,
        desc = "Word",
      },
      {
        "<leader>sW",
        function()
          require("snacks").picker.grep_word({ word_match = true })
        end,
        desc = "Word (exact)",
      },
      {
        "<leader>sC",
        function()
          require("snacks").picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sk",
        function()
          require("snacks").picker.keymaps()
        end,
        desc = "Key Maps",
      },
      {
        "<leader>sh",
        function()
          require("snacks").picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sM",
        function()
          require("snacks").picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sm",
        function()
          require("snacks").picker.marks()
        end,
        desc = "Jump to Mark",
      },
      {
        "<leader>sR",
        function()
          require("snacks").picker.resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>sx",
        function()
          require("snacks").picker.diagnostics_buffer()
        end,
        desc = "Document Diagnostics",
      },
      {
        "<leader>sX",
        function()
          require("snacks").picker.diagnostics()
        end,
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>ss",
        function()
          require("snacks").picker.lines()
        end,
        desc = "Search Buffer",
      },
      {
        "<leader>si",
        function()
          require("snacks").picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },

      -- LSP
      {
        "gd",
        function()
          require("snacks").picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gr",
        function()
          require("snacks").picker.lsp_references()
        end,
        desc = "References",
      },
      {
        "gI",
        function()
          require("snacks").picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          require("snacks").picker.lsp_type_definitions()
        end,
        desc = "Goto Type Definition",
      },
      {
        "<leader>sS",
        function()
          require("snacks").picker.lsp_workspace_symbols()
        end,
        desc = "Goto Symbol (Workspace)",
      },

      -- Notifications
      {
        "<leader>on",
        function()
          require("snacks").picker.notifications()
        end,
        desc = "Notifications",
      },

      -- Scratch buffers
      {
        "<leader>osn",
        function()
          require("snacks").scratch()
        end,
        desc = "New/Toggle",
      },
      {
        "<leader>oss",
        function()
          require("snacks").scratch.select()
        end,
        desc = "Select",
      },
      -- Disable LazyVim defaults
      { "<leader>n", false },
      { "<leader>N", false },
      { "<leader>S", false },

      -- Additional keybindings
      {
        "<leader><space>",
        function()
          require("snacks").picker.files({ cwd = vim.fn.getcwd() })
        end,
        desc = "Find Files",
      },
      {
        "<leader>bd",
        function()
          require("snacks").bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          require("snacks").rename()
        end,
        desc = "Rename File",
      },

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
              end,
            },
            format = "text",
            preview = false,
            confirm = function(picker, item)
              if not item then
                return
              end
              picker:close()
              vim.schedule(function()
                require("auto-session").RestoreSessionFile(item.file)
              end)
            end,
          })
        end,
        desc = "List Sessions",
      },
    },
  },
}
