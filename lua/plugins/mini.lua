-- Mini.nvim plugins collection
return {
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

  -- Better text objects
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

  -- Mini.files - Interactive file browser for adding projects
  {
    "nvim-mini/mini.files",
    event = "VeryLazy",
    config = function()
      local MiniFiles = require("mini.files")

      -- Custom action to select directory and open as project
      local select_project = function()
        local fs_entry = MiniFiles.get_fs_entry()
        if not fs_entry then return end

        local path = fs_entry.path

        -- If it's a file, use its directory
        local stat = vim.loop.fs_stat(path)
        if stat and stat.type == "file" then
          path = vim.fn.fnamemodify(path, ":h")
        end

        -- Close mini.files
        MiniFiles.close()

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

          -- Manually add project to project.nvim's recent list
          vim.schedule(function()
            local project_ok, project = pcall(require, "project")
            if project_ok then
              -- Get recent projects file path
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
            end
          end)

          -- Open file picker in the new project
          vim.schedule(function()
            vim.api.nvim_set_current_tabpage(target_tab)
            require("snacks").picker.files()
          end)
        end
      end

      MiniFiles.setup({
        windows = {
          preview = true,
          width_preview = 50,
        },
        mappings = {
          close = "q",
          go_in = "l",
          go_in_plus = "L",
          go_out = "h",
          go_out_plus = "H",
          reset = "<BS>",
          show_help = "g?",
          synchronize = "=",
          trim_left = "<",
          trim_right = ">",
        },
      })

      -- Set up autocmd to add 'a' mapping when mini.files buffer is opened
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "a", select_project, { buffer = buf_id, desc = "Add Project Directory" })
        end,
      })
    end,
    keys = {
      {
        "<leader>pa",
        function()
          local MiniFiles = require("mini.files")
          if not MiniFiles.close() then
            MiniFiles.open(vim.uv.cwd(), false)
          end
        end,
        desc = "Add Project (Browse)"
      },
    },
  },

  -- Jump to character
  {
    "nvim-mini/mini.jump",
    event = "VeryLazy",
    opts = {},
  },

  -- Bracket navigation (]b, [b, ]d, [d, etc.)
  {
    "nvim-mini/mini.bracketed",
    event = "VeryLazy",
    opts = {},
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
