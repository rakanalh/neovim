return {
  -- Project management
  {
    "DrKJeff16/project.nvim",
    event = "VeryLazy",
    main = "project",
    opts = {
      manual_mode = false,
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git" },
      ignore_lsp = {},
      exclude_dirs = { "~/" },
      show_hidden = false,
      silent_chdir = false,
      scope_chdir = "tab", -- Use tab-local directory changes
      datapath = vim.fn.stdpath("data"),
    },
  },

  -- Buffer isolation per tab (perspective-like functionality)
  {
    "tiagovla/scope.nvim",
    lazy = false, -- Load immediately for proper tab management
    config = function()
      require("scope").setup({
        hooks = {
          pre_tab_enter = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPre" })
          end,
          post_tab_enter = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabEnterPost" })
          end,
          pre_tab_leave = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePre" })
          end,
          post_tab_leave = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "ScopeTabLeavePost" })
          end,
        },
      })
      -- Note: scope.nvim works standalone (no picker extension needed)
    end,
  },

  -- Session management per project
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
      auto_session_use_git_branch = true,
      bypass_save_filetypes = { "alpha", "dashboard", "lazy" },
      close_unsupported_windows = true,
      cwd_change_handling = true,
      log_level = "error",
      session_lens = {
        load_on_setup = true,
        previewer = false,
        theme_conf = { border = true },
        mappings = {
          delete_session = { "i", "<C-D>" },
          alternate_session = { "i", "<C-S>" },
        },
      },
    },
    config = function(_, opts)
      require("auto-session").setup(opts)

      -- Auto-save session before switching projects
      vim.api.nvim_create_autocmd("User", {
        pattern = "ProjectPreChange",
        callback = function()
          require("auto-session").SaveSession()
        end,
      })

      -- Auto-load session after switching projects
      vim.api.nvim_create_autocmd("User", {
        pattern = "ProjectPostChange",
        callback = function()
          require("auto-session").RestoreSession()
        end,
      })

      -- Save session on quit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          require("auto-session").SaveSession()
        end,
      })
    end,
  },

  -- Tab/Workspace management keymaps
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    keys = {
      -- Tab/Workspace management
      { "<leader>pt", "<cmd>tabnew<cr>",      desc = "New Tab/Workspace" },
      {
        "<leader>pc",
        function()
          local tab_count = vim.fn.tabpagenr('$')
          if tab_count == 1 then
            -- If only one tab, clear project path and show dashboard
            pcall(vim.api.nvim_tabpage_del_var, 0, "project_path")
            vim.cmd("enew")
            vim.cmd("Dashboard")
          else
            -- Otherwise close the tab normally
            vim.cmd("tabclose")
          end
        end,
        desc = "Close Tab/Workspace"
      },
      { "<leader>pn", "<cmd>tabnext<cr>",     desc = "Next Tab/Workspace" },
      { "<leader>pN", "<cmd>tabprevious<cr>", desc = "Previous Tab/Workspace" },
      {
        "<leader>p]",
        function()
          -- Show tabs momentarily when switching
          vim.opt.showtabline = 2
          vim.cmd("tabnext")
          vim.defer_fn(function()
            vim.opt.showtabline = 0
          end, 2000)
        end,
        desc = "Next Tab/Workspace"
      },
      {
        "<leader>p[",
        function()
          -- Show tabs momentarily when switching
          vim.opt.showtabline = 2
          vim.cmd("tabprevious")
          vim.defer_fn(function()
            vim.opt.showtabline = 0
          end, 2000)
        end,
        desc = "Previous Tab/Workspace"
      },
      { "<leader>p1", "<cmd>tabn 1<cr>",                                       desc = "Go to Tab 1" },
      { "<leader>p2", "<cmd>tabn 2<cr>",                                       desc = "Go to Tab 2" },
      { "<leader>p3", "<cmd>tabn 3<cr>",                                       desc = "Go to Tab 3" },
      { "<leader>p4", "<cmd>tabn 4<cr>",                                       desc = "Go to Tab 4" },
      { "<leader>p5", "<cmd>tabn 5<cr>",                                       desc = "Go to Tab 5" },

      -- Session management
      { "<leader>qs", function() require("auto-session").SaveSession() end,    desc = "Save Session" },
      { "<leader>qr", function() require("auto-session").RestoreSession() end, desc = "Restore Session" },
      { "<leader>qd", function() require("auto-session").DeleteSession() end,  desc = "Delete Session" },
    },
  },

  -- Disable bufferline to hide tabs completely
  {
    "akinsho/bufferline.nvim",
    enabled = false, -- Completely disable bufferline
  },

  -- Helper for closing buffers
  {
    "nvim-mini/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
}

