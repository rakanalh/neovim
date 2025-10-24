return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          local telescope = require("telescope")
          local current_dir = vim.fn.expand("%:p:h")
          local root = require("lazyvim.util").root()

          -- Custom action to add selected directory as project
          local add_project_action = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local actions = require("telescope.actions")
            local selection = action_state.get_selected_entry()

            if not selection then return end

            local path = selection.path or selection.value

            -- If it's a file, use its directory
            local stat = vim.loop.fs_stat(path)
            if stat and stat.type == "file" then
              path = vim.fn.fnamemodify(path, ":h")
            end

            -- Close telescope
            actions.close(prompt_bufnr)

            -- Normalize path
            local project_path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")

            -- Check if this project is already open in a tab
            local tabs = vim.api.nvim_list_tabpages()
            local existing_tab = nil

            for _, tab in ipairs(tabs) do
              local ok, tab_project = pcall(vim.api.nvim_tabpage_get_var, tab, "project_path")
              if ok and tab_project then
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
              -- Create new tab
              vim.cmd("$tabnew")
              vim.cmd("tcd " .. vim.fn.fnameescape(path))
              local target_tab = vim.api.nvim_get_current_tabpage()
              vim.api.nvim_tabpage_set_var(target_tab, "project_path", project_path)

              -- Add project to project.nvim's recent list
              vim.schedule(function()
                -- Write to history file for persistence
                local data_path = vim.fn.stdpath("data")
                local history_path = data_path .. "/project_nvim/project_history"

                -- Read existing projects
                local projects = {}
                local file = io.open(history_path, "r")
                if file then
                  for line in file:lines() do
                    if line ~= "" and line ~= project_path then
                      table.insert(projects, line)
                    end
                  end
                  file:close()
                end

                -- Add new project at the top
                table.insert(projects, 1, project_path)

                -- Write back
                vim.fn.mkdir(vim.fn.fnamemodify(history_path, ":h"), "p")
                file = io.open(history_path, "w")
                if file then
                  for _, proj in ipairs(projects) do
                    file:write(proj .. "\n")
                  end
                  file:close()
                end

                -- Trigger DirChanged event to update project.nvim's in-memory state
                vim.api.nvim_exec_autocmds("DirChanged", { pattern = "tabpage" })
              end)

              -- Open file picker in the new project
              vim.schedule(function()
                vim.api.nvim_set_current_tabpage(target_tab)
                require("snacks").picker.files()
              end)
            end
          end

          telescope.extensions.file_browser.file_browser({
            path = current_dir,
            cwd = root,
            respect_gitignore = false,
            hidden = true,
            grouped = false,
            previewer = false,
            initial_mode = "insert",
            sorting_strategy = "ascending",
            layout_strategy = "bottom_pane",
            layout_config = {
              height = 0.3,
              prompt_position = "top",
            },
            display_stat = { date = true, size = true, mode = true },
            git_status = true,
            attach_mappings = function(prompt_bufnr, map)
              local actions = require("telescope.actions")
              map("i", "<Tab>", actions.select_default)
              map("n", "<Tab>", actions.select_default)
              map("n", "a", add_project_action)
              return true
            end,
          })
        end,
        desc = "File Browser (Current Dir)",
      },
      {
        "<leader>pa",
        function()
          local telescope = require("telescope")
          local cwd = vim.uv.cwd()
          local root = require("lazyvim.util").root()

          -- Custom action to add selected directory as project
          local add_project_action = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local actions = require("telescope.actions")
            local selection = action_state.get_selected_entry()

            if not selection then return end

            local path = selection.path or selection.value

            -- If it's a file, use its directory
            local stat = vim.loop.fs_stat(path)
            if stat and stat.type == "file" then
              path = vim.fn.fnamemodify(path, ":h")
            end

            -- Close telescope
            actions.close(prompt_bufnr)

            -- Normalize path
            local project_path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")

            -- Check if this project is already open in a tab
            local tabs = vim.api.nvim_list_tabpages()
            local existing_tab = nil

            for _, tab in ipairs(tabs) do
              local ok, tab_project = pcall(vim.api.nvim_tabpage_get_var, tab, "project_path")
              if ok and tab_project then
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
              -- Create new tab
              vim.cmd("$tabnew")
              vim.cmd("tcd " .. vim.fn.fnameescape(path))
              local target_tab = vim.api.nvim_get_current_tabpage()
              vim.api.nvim_tabpage_set_var(target_tab, "project_path", project_path)

              -- Add project to project.nvim's recent list
              vim.schedule(function()
                -- Write to history file for persistence
                local data_path = vim.fn.stdpath("data")
                local history_path = data_path .. "/project_nvim/project_history"

                -- Read existing projects
                local projects = {}
                local file = io.open(history_path, "r")
                if file then
                  for line in file:lines() do
                    if line ~= "" and line ~= project_path then
                      table.insert(projects, line)
                    end
                  end
                  file:close()
                end

                -- Add new project at the top
                table.insert(projects, 1, project_path)

                -- Write back
                vim.fn.mkdir(vim.fn.fnamemodify(history_path, ":h"), "p")
                file = io.open(history_path, "w")
                if file then
                  for _, proj in ipairs(projects) do
                    file:write(proj .. "\n")
                  end
                  file:close()
                end

                -- Trigger DirChanged event to update project.nvim's in-memory state
                vim.api.nvim_exec_autocmds("DirChanged", { pattern = "tabpage" })
              end)

              -- Open file picker in the new project
              vim.schedule(function()
                vim.api.nvim_set_current_tabpage(target_tab)
                require("snacks").picker.files()
              end)
            end
          end

          telescope.extensions.file_browser.file_browser({
            path = cwd,
            cwd = root,
            respect_gitignore = false,
            hidden = true,
            grouped = false,
            previewer = false,
            initial_mode = "insert",
            sorting_strategy = "ascending",
            layout_strategy = "bottom_pane",
            layout_config = {
              height = 0.3,
              prompt_position = "top",
            },
            display_stat = { date = true, size = true, mode = true },
            git_status = true,
            attach_mappings = function(prompt_bufnr, map)
              local actions = require("telescope.actions")
              map("i", "<Tab>", actions.select_default)
              map("n", "<Tab>", actions.select_default)
              map("n", "a", add_project_action)
              return true
            end,
          })
        end,
        desc = "Add Project (Browse)",
      },
    },
    opts = function()
      local fb_actions = require("telescope").extensions.file_browser.actions
      local actions = require("telescope.actions")

      return {
        extensions = {
          file_browser = {
            theme = "ivy",
            hijack_netrw = false,
            prompt_path = true,
            cwd_to_path = true,
            mappings = {
              ["i"] = {
                ["<BS>"] = fb_actions.goto_parent_dir,
              },
              ["n"] = {
                ["<BS>"] = fb_actions.goto_parent_dir,
              },
            },
          },
        },
      }
    end,
  },
}
