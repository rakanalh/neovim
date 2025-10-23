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
              return true
            end,
          })
        end,
        desc = "File Browser (Current Dir)",
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
