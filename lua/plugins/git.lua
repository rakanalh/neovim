return {
  -- Neogit - Magit clone for Neovim
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-treesitter/nvim-treesitter", -- For syntax highlighting
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (Magit)" },
      { "<leader>gG", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Neogit (cwd)" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git Commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Git Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Git Push" },
      { "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", "<cmd>Neogit log<cr>", desc = "Git Log" },
    },
    opts = {
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      disable_insert_on_commit = "auto",
      auto_refresh = true,
      disable_builtin_notifications = false,
      console_timeout = 2000,
      auto_show_console = true,
      remember_settings = true,
      use_per_project_settings = true,
      ignored_settings = {
        "NeogitPushPopup--force-with-lease",
        "NeogitPushPopup--force",
        "NeogitPullPopup--rebase",
        "NeogitCommitPopup--allow-empty",
        "NeogitRevertPopup--no-edit",
      },
      highlight = {
        bold = true,
        italic = true,
        underline = true,
      },
      use_default_keymaps = true,
      kind = "vsplit",
      commit_editor = {
        kind = "vsplit",
        show_staged_diff = true,
      },
      commit_select_view = {
        kind = "vsplit",
      },
      commit_view = {
        kind = "vsplit",
      },
      log_view = {
        kind = "vsplit",
      },
      rebase_editor = {
        kind = "vsplit",
      },
      reflog_view = {
        kind = "vsplit",
      },
      merge_editor = {
        kind = "vsplit",
      },
      tag_editor = {
        kind = "vsplit",
      },
      preview_buffer = {
        kind = "vsplit",
      },
      popup = {
        kind = "vsplit",
      },
      signs = {
        hunk = { "", "" },
        item = { "▸", "▾" },
        section = { "▸", "▾" },
      },
      integrations = {
        diffview = true,
        fzf_lua = false,
      },
      disable_line_numbers = true, -- Disable line numbers in Neogit buffer
      sections = {
        untracked = {
          folded = false,
          hidden = false,
        },
        unstaged = {
          folded = false,
          hidden = false,
        },
        staged = {
          folded = false,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        unmerged_upstream = {
          folded = false,
          hidden = false,
        },
        unpulled_pushRemote = {
          folded = true,
          hidden = false,
        },
        unmerged_pushRemote = {
          folded = false,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
        rebase = {
          folded = true,
          hidden = false,
        },
      },
      -- Use default mappings (they handle popups correctly)
    },
    config = function(_, opts)
      local neogit = require("neogit")
      neogit.setup(opts)
      -- Theme will handle the colors
    end,
  },
  
  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        
        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        
        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        
        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  
  -- Diffview for better diff visualization
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
    },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      commit_log_panel = {
        win_config = {
          win_opts = {},
        },
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      keymaps = {
        disable_defaults = false,
        view = {
          ["<tab>"]      = false, -- Disabled to not conflict with your custom tab bindings
          ["<s-tab>"]    = false, -- Disabled to not conflict with your custom tab bindings
          ["gf"]         = "<cmd>DiffviewGotoFile<cr>",
          ["<C-w><C-f>"] = "<cmd>DiffviewGotoFile split<cr>",
          ["<C-w>gf"]    = "<cmd>DiffviewGotoFile tab<cr>",
          ["<leader>e"]  = "<cmd>DiffviewFocusFiles<cr>",
          ["<leader>b"]  = "<cmd>DiffviewToggleBlame<cr>",
        },
        diff1 = {
          ["g?"] = "<cmd>DiffviewHelp<cr>",
        },
        diff2 = {
          ["g?"] = "<cmd>DiffviewHelp<cr>",
        },
        diff3 = {
          ["g?"] = "<cmd>DiffviewHelp<cr>",
        },
        diff4 = {
          ["g?"] = "<cmd>DiffviewHelp<cr>",
        },
        file_panel = {
          ["j"]             = false,
          ["<down>"]        = false,
          ["k"]             = false,
          ["<up>"]          = false,
          ["<cr>"]          = false,
          ["o"]             = false,
          ["<2-LeftMouse>"] = false,
          ["-"]             = false,
          ["S"]             = false,
          ["s"]             = false,
          ["R"]             = false,
          ["<tab>"]         = false, -- Disabled to not conflict with your custom tab bindings
          ["i"]             = false,
          ["f"]             = false,
          ["<c-b>"]         = false,
          ["<c-f>"]         = false,
          ["<c-d>"]         = false,
          ["<c-u>"]         = false,
          ["]d"]            = false,
          ["[d"]            = false,
          ["gf"]            = false,
          ["<C-w><C-f>"]    = false,
          ["<C-w>gf"]       = false,
          ["<leader>e"]     = false,
          ["<leader>b"]     = false,
          ["g<C-x>"]        = false,
          ["g?"]            = false,
        },
        file_history_panel = {
          ["g!"]            = false,
          ["<C-A-d>"]       = false,
          ["<C-d>"]         = false,
          ["<tab>"]         = false, -- Disabled to not conflict with your custom tab bindings
          ["<s-tab>"]       = false, -- Disabled to not conflict with your custom tab bindings
          ["gf"]            = false,
          ["<C-w><C-f>"]    = false,
          ["<C-w>gf"]       = false,
          ["o"]             = false,
          ["<cr>"]          = false,
          ["<2-LeftMouse>"] = false,
          ["y"]             = false,
          ["L"]             = false,
          ["zR"]            = false,
          ["zM"]            = false,
          ["j"]             = false,
          ["<down>"]        = false,
          ["k"]             = false,
          ["<up>"]          = false,
          ["]d"]            = false,
          ["[d"]            = false,
          ["<leader>e"]     = false,
          ["<leader>b"]     = false,
          ["g<C-x>"]        = false,
          ["g?"]            = false,
        },
        option_panel = {
          ["<tab>"] = false, -- Disabled to not conflict with your custom tab bindings
          ["q"]     = false,
        },
        help_panel = {
          ["q"] = false,
        },
      },
    },
  },
}