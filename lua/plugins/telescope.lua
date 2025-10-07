-- Telescope - Fuzzy finder and search
return {
  -- Main telescope configuration
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
      },
    },
    keys = {
      -- Project management
      {
        "<leader>pp",
        function()
          require("telescope").extensions.projects.projects({
            attach_mappings = function(prompt_bufnr, map)
              local action_state = require("telescope.actions.state")
              local actions = require("telescope.actions")

              -- Override the default <CR> action
              map("i", "<CR>", function()
                local selection = action_state.get_selected_entry()
                if selection then
                  actions.close(prompt_bufnr)

                  -- Normalize the selected project path
                  local project_path = vim.fn.fnamemodify(selection.value, ":p"):gsub("/$", "")

                  -- Check if this project is already open in a tab
                  local tabs = vim.api.nvim_list_tabpages()
                  local existing_tab = nil
                  local has_project_tabs = false

                  for i, tab in ipairs(tabs) do
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
                      vim.cmd("tcd " .. vim.fn.fnameescape(selection.value))
                      vim.api.nvim_tabpage_set_var(0, "project_path", project_path)
                    else
                      vim.cmd("$tabnew")
                      vim.cmd("tcd " .. vim.fn.fnameescape(selection.value))
                      vim.api.nvim_tabpage_set_var(0, "project_path", project_path)
                    end

                    -- Open file picker
                    require("telescope.builtin").find_files()
                  end
                end
              end)

              map("n", "<CR>", function()
                local selection = action_state.get_selected_entry()
                if selection then
                  actions.close(prompt_bufnr)

                  -- Same logic for normal mode
                  local project_path = vim.fn.fnamemodify(selection.value, ":p"):gsub("/$", "")
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
                    vim.api.nvim_set_current_tabpage(existing_tab)
                  else
                    if not has_project_tabs then
                      vim.cmd("tcd " .. vim.fn.fnameescape(selection.value))
                      vim.api.nvim_tabpage_set_var(0, "project_path", project_path)
                    else
                      vim.cmd("$tabnew")
                      vim.cmd("tcd " .. vim.fn.fnameescape(selection.value))
                      vim.api.nvim_tabpage_set_var(0, "project_path", project_path)
                    end
                    require("telescope.builtin").find_files()
                  end
                end
              end)

              return true
            end
          })
        end,
        desc = "Switch Project (New Tab)"
      },
      {
        "<leader>pP",
        function()
          -- Open project in current tab
          require("telescope").extensions.projects.projects({
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local project = require("telescope.actions.state").get_selected_entry()
                if project then
                  require("telescope.actions").close(prompt_bufnr)
                  -- Use current tab, just change directory
                  vim.cmd("tcd " .. project.value)
                  require("telescope.builtin").find_files()
                end
              end)
              return true
            end
          })
        end,
        desc = "Open Project in Current Tab"
      },

      -- File finding
      { "<leader>pf", "<cmd>Telescope find_files<cr>",                                                          desc = "Find File in Project" },
      { "<leader>ps", "<cmd>Telescope live_grep<cr>",                                                           desc = "Search in Project" },
      { "<leader>pb", "<cmd>Telescope buffers<cr>",                                                             desc = "Project Buffers" },
      { "<leader>pr", "<cmd>Telescope oldfiles<cr>",                                                            desc = "Recent Project Files" },
      { "<leader>p.", function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find File in Current Directory" },

      -- Frecency-based file finding
      { "<leader>fr", "<cmd>Telescope frecency<cr>",                                                            desc = "Recent Files (Frecency)" },
      { "<leader>fR", "<cmd>Telescope frecency workspace=CWD<cr>",                                              desc = "Recent Files in CWD (Frecency)" },

      -- Buffer management within tab (with scope.nvim)
      { "<leader>b,", "<cmd>Telescope scope buffers<cr>",                                                       desc = "Tab Buffers" },

      -- Session management
      { "<leader>ql", "<cmd>Telescope session-lens<cr>",                                                        desc = "List Sessions" },

      -- Git integration
      { "<leader>gc", "<cmd>Telescope git_commits<cr>",                                                         desc = "Git Commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>",                                                        desc = "Git Branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",                                                          desc = "Git Status" },

      -- Search
      { "<leader>sp", "<cmd>Telescope live_grep<cr>",                                                           desc = "Search Project" },
      {
        "<leader>sp",
        mode = "v",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Selection"
      },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>",                                               desc = "Word" },
      { "<leader>sW", function() require("telescope.builtin").grep_string({ word_match = "-w" }) end, desc = "Word (exact)" },
      { "<leader>sC", "<cmd>Telescope commands<cr>",                                                  desc = "Commands" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                                   desc = "Key Maps" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",                                                 desc = "Help Pages" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>",                                                 desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>",                                                     desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>",                                               desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>",                                                    desc = "Resume" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>",                                       desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>",                                               desc = "Workspace Diagnostics" },

      -- LSP
      { "gd",         "<cmd>Telescope lsp_definitions<cr>",                                           desc = "Goto Definition" },
      { "gr",         "<cmd>Telescope lsp_references<cr>",                                            desc = "References" },
      { "gI",         "<cmd>Telescope lsp_implementations<cr>",                                       desc = "Goto Implementation" },
      { "gy",         "<cmd>Telescope lsp_type_definitions<cr>",                                      desc = "Goto Type Definition" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                             desc = "Goto Symbol (Workspace)" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_strategy = "bottom_pane",
        layout_config = {
          bottom_pane = {
            height = 25,
            preview_cutoff = 120,
            prompt_position = "top"
          },
          center = {
            height = 0.4,
            preview_cutoff = 40,
            prompt_position = "top",
            width = 0.5
          },
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8
          },
          vertical = {
            mirror = false,
            prompt_position = "top"
          },
        },
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        mappings = {
          i = {
            ["<C-j>"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["<C-k>"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["<C-p>"] = function(...)
              return require("telescope.actions.layout").toggle_preview(...)
            end,
            ["<C-u>"] = function(...)
              return require("telescope.actions").preview_scrolling_up(...)
            end,
            ["<C-d>"] = function(...)
              return require("telescope.actions").preview_scrolling_down(...)
            end,
          },
          n = {
            ["q"] = function(...)
              return require("telescope.actions").close(...)
            end,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          "%.git/",
          "%.DS_Store",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob",
          "!.git/*",
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            n = {
              ["dd"] = function(...)
                return require("telescope.actions").delete_buffer(...)
              end,
            },
          },
        },
        git_branches = {
          theme = "dropdown",
          initial_mode = "normal",
          mappings = {
            n = {
              ["<cr>"] = function(...)
                return require("telescope.actions").git_switch_branch(...)
              end,
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        frecency = {
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
          disable_devicons = false,
          workspaces = {
            ["conf"] = vim.fn.expand("~/.config"),
            ["project"] = vim.fn.expand("~/projects"),
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load extensions
      if vim.fn.executable("make") == 1 then
        telescope.load_extension("fzf")
      end
      telescope.load_extension("frecency")

      -- Try to load optional extensions
      pcall(telescope.load_extension, "projects")
      pcall(telescope.load_extension, "scope")
      pcall(telescope.load_extension, "yank_history")
      pcall(telescope.load_extension, "session-lens")
    end,
  },

  -- Override snacks_picker LSP keymaps to use our custom bindings

  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      for i = #keys, 1, -1 do
        if keys[i][1] == "<leader>ss" then
          table.remove(keys, i)   -- drop LazyVim’s buffer-local override
        end
      end
    end,
  },
}
