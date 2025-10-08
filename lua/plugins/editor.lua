return {
  -- UFO - Better folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      open_fold_hl_timeout = 0, -- No animation, instant highlight
      close_fold_kinds = {},
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Fold Less" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Fold More" },
      { "zK", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, desc = "Peek Fold or Hover" },
    },
    config = function(_, opts)
      require("ufo").setup(opts)
      -- Override fold settings
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },

  -- Comment.nvim - Smart commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Add a space between comment and the line
      padding = true,
      -- Whether the cursor should stay at its position
      sticky = true,
      -- Lines to be ignored while (un)comment
      ignore = nil,
      -- LHS of toggle mappings in NORMAL mode
      toggler = {
        -- Line-comment toggle keymap
        line = "gcc",
        -- Block-comment toggle keymap
        block = "gbc",
      },
      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        -- Line-comment keymap
        line = "gc",
        -- Block-comment keymap
        block = "gb",
      },
      -- LHS of extra mappings
      extra = {
        -- Add comment on the line above
        above = "gcO",
        -- Add comment on the line below
        below = "gco",
        -- Add comment at the end of line
        eol = "gcA",
      },
      -- Enable keybindings
      mappings = {
        -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        -- Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      -- Function to call before (un)comment
      pre_hook = nil,
      -- Function to call after (un)comment
      post_hook = nil,
    },
  },
  
  -- nvim-surround - Add/change/delete surrounding pairs
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  
  -- todo-comments.nvim - Highlight and search TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      -- Configure search
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", function() require("snacks").picker.grep({ search = "\\b(TODO|FIXME|FIX|HACK|WARN|PERF|NOTE|TEST):" }) end, desc = "Todo" },
      { "<leader>sT", function() require("snacks").picker.grep({ search = "\\b(TODO|FIX|FIXME):" }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  
  
  -- nvim-treesitter-context - Sticky header showing current context
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
    keys = {
      { "[c", function() require("treesitter-context").go_to_context(vim.v.count1) end, desc = "Jump to context" },
      { "<leader>uC", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter Context" },
    },
  },
  
  -- EditorConfig support
  {
    "editorconfig/editorconfig-vim",
    event = { "BufReadPre", "BufNewFile" },
  },
  
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      { "<leader>fE", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "Explorer NeoTree (cwd)" },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
          never_show = {},
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
  },
  
  -- which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "classic", -- This forces bottom layout
      layout = {
        width = { max = 999 }, -- Use maximum available width
        height = { min = 1, max = 10 }, -- Reduce height (default is usually 25)
        align = "left", -- Align to left to use full width
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- Register key groups
      wk.add({
        { "<leader>", group = "Leader" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>h", group = "harpoon" },
        { "<leader>m", group = "multi-cursor" },
        { "<leader>o", group = "overseer" },
        { "<leader>p", group = "project" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "terminal" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader><tab>", group = "tabs" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        { "[", group = "prev" },
        { "]", group = "next" },
      })
    end,
  },
  
  -- Search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    },
  },

  -- Auto pairs
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>up",
        function()
          local util = require("lazy.core.util")
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            util.warn("Disabled auto pairs", { title = "Option" })
          else
            util.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle Auto Pairs",
      },
    },
  },
  
  -- Surround
  {
    "nvim-mini/mini.surround",
    recommended = true,
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local opts = require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["mini.surround"], "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete Surrounding" },
        { opts.mappings.find, desc = "Find Right Surrounding" },
        { opts.mappings.find_left, desc = "Find Left Surrounding" },
        { opts.mappings.highlight, desc = "Highlight Surrounding" },
        { opts.mappings.replace, desc = "Replace Surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  
  -- Comments
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  
  -- Multi-cursor support
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",         -- Select word under cursor
        ["Find Subword Under"] = "<C-n>", -- Select subword under cursor
        ["Select All"] = "<leader>ma",    -- Select all occurrences
        ["Select h"] = "<C-Left>",        -- Reduce selection
        ["Select l"] = "<C-Right>",       -- Expand selection
        ["Add Cursor Down"] = "<C-M-j>",  -- Add cursor down
        ["Add Cursor Up"] = "<C-M-k>",    -- Add cursor up
        ["Add Cursor At Pos"] = "<C-M-p>", -- Add cursor at click position
        ["Visual Regex"] = "<leader>m/",  -- Select via regex
        ["Visual All"] = "<leader>mA",    -- Select all in visual mode
        ["Visual Add"] = "<leader>ma",    -- Add selection in visual mode
        ["Visual Find"] = "<leader>mf",   -- Find in visual mode
        ["Visual Cursors"] = "<leader>mc", -- Create cursors from visual selection
        ["Mouse Cursor"] = "<C-LeftMouse>", -- Add cursor with mouse
        ["Mouse Word"] = "<C-RightMouse>", -- Select word with mouse
        ["Mouse Column"] = "<M-C-RightMouse>", -- Column selection with mouse
      }
      -- Theme - use default to inherit from colorscheme
      vim.g.VM_theme = "default"
      -- Show messages
      vim.g.VM_show_warnings = 1
      -- Highlight matches
      vim.g.VM_highlight_matches = "underline"
      -- Use single leader for mappings
      vim.g.VM_leader = "\\\\"
      -- Don't override color scheme highlights
      vim.g.VM_theme_set_by_colorscheme = 1
    end,
    keys = {
      { "<C-n>", mode = { "n", "v" }, desc = "Select word/selection" },
      { "<C-M-j>", mode = { "n" }, desc = "Add cursor down" },
      { "<C-M-k>", mode = { "n" }, desc = "Add cursor up" },
      { "<leader>ma", mode = { "n", "v" }, desc = "Select all occurrences" },
      { "<leader>m/", mode = { "n" }, desc = "Select via regex" },
      { "<leader>mc", mode = { "v" }, desc = "Create cursors from selection" },
    },
  },
  
  -- Better text objects
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = function() -- Whole buffer, similar to `gg` and 'G' motion
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
  },

  -- Overseer.nvim - Task runner and job management
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild" },
    opts = {
      -- No animations, instant feedback
      dap = false,
      task_list = {
        default_detail = 1,
        max_width = { 100, 0.2 },
        min_width = { 40, 0.1 },
        width = nil,
        max_height = { 20, 0.3 },
        min_height = 8,
        height = nil,
        preview_min_width = 80,
        direction = "bottom",
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["P"] = "IncreasePreview",
          ["<C-p>"] = "DecreasePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },
      form = {
        border = "rounded",
        zindex = 40,
        min_width = 80,
        max_width = 0.9,
        min_height = 10,
        max_height = 0.9,
        win_opts = {
          winblend = 0,
        },
      },
      task_launcher = {
        bindings = {
          i = {
            ["<C-s>"] = "Submit",
            ["<C-c>"] = "Cancel",
          },
          n = {
            ["<CR>"] = "Submit",
            ["<C-s>"] = "Submit",
            ["q"] = "Cancel",
            ["?"] = "ShowHelp",
          },
        },
      },
      task_editor = {
        bindings = {
          i = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
            ["<C-c>"] = "Cancel",
          },
          n = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
            ["q"] = "Cancel",
            ["?"] = "ShowHelp",
          },
        },
      },
    },
    keys = {
      { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer Task Action" },
      { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Overseer Clear Cache" },
    },
  },
}