-- GitHub integration plugin
return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    config = function()
      require("octo").setup({
        use_local_fs = true,                       -- Use local files on right side of reviews
        enable_builtin = false,                    -- Shows a list of builtin actions when no action is provided
        default_remote = { "upstream", "origin" }, -- Order to try remotes
        default_merge_method = "commit",           -- Merge method to use when merging PRs (commit, rebase, squash)
        ssh_aliases = {},                          -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
        picker = "telescope",                      -- or "fzf-lua"
        picker_config = {
          use_emojis = false,                      -- only used by "fzf-lua" picker for now
          mappings = {                             -- mappings for the pickers
            open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
            copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
            checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
            merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
          },
        },
        comment_icon = "▎", -- Comment marker
        outdated_icon = "󰅒 ", -- Icon for outdated comments
        resolved_icon = " ", -- Icon for resolved items
        reaction_viewer_hint_icon = " ", -- Marker for user reactions
        user_icon = " ",
        timeline_marker = " ",
        timeline_indent = 2,            -- Timeline indentation
        right_bubble_delimiter = "",    -- Right bubble delimiter
        left_bubble_delimiter = "",     -- Left bubble delimiter
        snippet_context_lines = 4,      -- Number of lines around commented lines
        gh_cmd = "gh",                  -- Command to use when calling GitHub CLI
        gh_env = {},                    -- Extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
        timeout = 5000,                 -- Timeout for requests between the remote repo and GitHub CLI
        default_to_projects_v2 = false, -- Use projects v2 for the `Octo card ...` command by default
        ui = {
          use_signcolumn = true,        -- Show "modified" marks on the sign column
        },
        issues = {
          order_by = {            -- criteria to sort results of `Octo issue list`
            field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
            direction =
            "DESC"                -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
          }
        },
        pull_requests = {
          order_by = {                           -- criteria to sort the results of `Octo pr list`
            field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
            direction =
            "DESC"                               -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
          },
          always_select_remote_on_create = false -- always give prompt to select base remote repo when creating PRs
        },
        file_panel = {
          size = 10,       -- Changed files panel rows
          use_icons = true -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
        },
        colors = {         -- used for highlight groups (see Colors section below)
          white = "#ffffff",
          grey = "#2A354C",
          black = "#000000",
          red = "#fdb8c0",
          dark_red = "#da3633",
          green = "#acf2bd",
          dark_green = "#238636",
          yellow = "#d3c846",
          dark_yellow = "#735c0f",
          blue = "#58A6FF",
          dark_blue = "#0366d6",
          purple = "#6f42c1",
        },
      })
    end,
    keys = {
      { "<leader>go",  "<cmd>Octo<cr>",              desc = "Octo" },
      { "<leader>goi", "<cmd>Octo issue list<cr>",   desc = "List Issues" },
      { "<leader>goI", "<cmd>Octo issue search<cr>", desc = "Search Issues" },
      { "<leader>gop", "<cmd>Octo pr list<cr>",      desc = "List PRs" },
      { "<leader>goP", "<cmd>Octo pr search<cr>",    desc = "Search PRs" },
      { "<leader>gor", "<cmd>Octo repo list<cr>",    desc = "List Repos" },
      { "<leader>gos", "<cmd>Octo search<cr>",       desc = "Search" },

      -- In PR/Issue buffer
      { "<leader>goa", "<cmd>Octo assignee<cr>",     desc = "Assignee",     ft = "octo" },
      { "<leader>goc", "<cmd>Octo comment<cr>",      desc = "Comment",      ft = "octo" },
      { "<leader>gol", "<cmd>Octo label<cr>",        desc = "Label",        ft = "octo" },
      { "<leader>gor", "<cmd>Octo pr changes<cr>",   desc = "PR Changes",   ft = "octo" },
      { "<leader>goR", "<cmd>Octo review start<cr>", desc = "Start Review", ft = "octo" },
      { "<leader>got", "<cmd>Octo thread<cr>",       desc = "Thread",       ft = "octo" },
    },
  },
}

