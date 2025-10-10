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
      show_hidden = false,
      silent_chdir = true,
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
      -- Tab switching with <leader><tab> prefix
      { "<leader><tab>1", "<cmd>tabn 1<cr>", desc = "Go to Tab 1" },
      { "<leader><tab>2", "<cmd>tabn 2<cr>", desc = "Go to Tab 2" },
      { "<leader><tab>3", "<cmd>tabn 3<cr>", desc = "Go to Tab 3" },
      { "<leader><tab>4", "<cmd>tabn 4<cr>", desc = "Go to Tab 4" },
      { "<leader><tab>5", "<cmd>tabn 5<cr>", desc = "Go to Tab 5" },
      { "<leader><tab>6", "<cmd>tabn 6<cr>", desc = "Go to Tab 6" },
      { "<leader><tab>7", "<cmd>tabn 7<cr>", desc = "Go to Tab 7" },
      { "<leader><tab>8", "<cmd>tabn 8<cr>", desc = "Go to Tab 8" },
      { "<leader><tab>9", "<cmd>tabn 9<cr>", desc = "Go to Tab 9" },

      -- Project switching
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
                local target_tab
                if not has_project_tabs then
                  vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
                  vim.api.nvim_tabpage_set_var(0, "project_path", project_path)
                  target_tab = vim.api.nvim_get_current_tabpage()
                else
                  vim.cmd("$tabnew")
                  vim.cmd("tcd " .. vim.fn.fnameescape(item.file))
                  target_tab = vim.api.nvim_get_current_tabpage()
                  vim.api.nvim_tabpage_set_var(target_tab, "project_path", project_path)
                end
                -- Open file picker in the target tab
                vim.schedule(function()
                  vim.api.nvim_set_current_tabpage(target_tab)
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
      {
        "<leader>px",
        function()
          require("snacks").picker.projects({
            confirm = function(picker, item)
              if not item then return end
              picker:close()

              local project_path = vim.fn.fnamemodify(item.file, ":p"):gsub("/$", "")

              -- Remove project from project.nvim's history file
              vim.schedule(function()
                local data_path = vim.fn.stdpath("data")
                local history_path = data_path .. "/project_nvim/project_history"

                -- Read existing projects
                local projects = {}
                local file = io.open(history_path, "r")
                if file then
                  for line in file:lines() do
                    local normalized_line = vim.fn.fnamemodify(line, ":p"):gsub("/$", "")
                    if line ~= "" and normalized_line ~= project_path then
                      table.insert(projects, line)
                    end
                  end
                  file:close()
                end

                -- Write back without the removed project
                file = io.open(history_path, "w")
                if file then
                  for _, proj in ipairs(projects) do
                    file:write(proj .. "\n")
                  end
                  file:close()
                  vim.notify("Removed project: " .. vim.fn.fnamemodify(project_path, ":t"), vim.log.levels.INFO)
                else
                  vim.notify("Failed to remove project", vim.log.levels.ERROR)
                end
              end)
            end,
          })
        end,
        desc = "Remove Project from List"
      },

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
}
