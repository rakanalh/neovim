return {
  -- Treesitter - Override LazyVim's parser list with our own
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true, -- Automatically install missing parsers when entering buffer
      -- Replace LazyVim's ensure_installed with only our parsers
      ensure_installed = {
        "cmake",
        "comment",
        "css",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "graphql",
        "http",
        "json5",
        "make",
        "proto",
        "rust",
        "scss",
        "sql",
      },
      indent = {
        enable = true,
        disable = { "python" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = false },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "grr",
          },
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = "gnd",
            list_definitions = "gnD",
            list_definitions_toc = "gO",
            goto_next_usage = "<a-*>",
            goto_previous_usage = "<a-#>",
          },
        },
      },
    },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>",      desc = "Decrement Selection", mode = "x" },
    },
  },

  -- nvim-treesitter-textobjects - Extend LazyVim's configuration
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- LazyVim doesn't provide select textobjects by default, add our custom ones
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["ap"] = "@parameter.outer",
          ["ip"] = "@parameter.inner",
          ["as"] = "@statement.outer",
          ["is"] = "@statement.inner",
          ["am"] = "@comment.outer",
          ["im"] = "@comment.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",
        },
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V",  -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        -- Extend LazyVim's move keymaps with additional textobjects
        goto_next_start = {
          ["]l"] = "@loop.outer",
          ["]b"] = "@block.outer",
          ["]p"] = "@parameter.outer",
          ["]s"] = "@statement.outer",
          ["]m"] = "@comment.outer",
          ["]i"] = "@conditional.outer",
        },
        goto_next_end = {
          ["]L"] = "@loop.outer",
          ["]B"] = "@block.outer",
          ["]P"] = "@parameter.outer",
          ["]S"] = "@statement.outer",
          ["]M"] = "@comment.outer",
          ["]I"] = "@conditional.outer",
        },
        goto_previous_start = {
          ["[l"] = "@loop.outer",
          ["[b"] = "@block.outer",
          ["[p"] = "@parameter.outer",
          ["[s"] = "@statement.outer",
          ["[m"] = "@comment.outer",
          ["[i"] = "@conditional.outer",
        },
        goto_previous_end = {
          ["[L"] = "@loop.outer",
          ["[B"] = "@block.outer",
          ["[P"] = "@parameter.outer",
          ["[S"] = "@statement.outer",
          ["[M"] = "@comment.outer",
          ["[I"] = "@conditional.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
      lsp_interop = {
        enable = true,
        border = "none",
        floating_preview_opts = {},
        peek_definition_code = {
          ["<leader>df"] = "@function.outer",
          ["<leader>dF"] = "@class.outer",
        },
      },
    },
  },

  -- nvim-treesitter-context - Sticky header showing current context
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      enable = true,
      multiwindow = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
      zindex = 20,
      on_attach = function(buf)
        -- Disable for markdown files
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        if filetype == "markdown" then
          return false
        end
        return true
      end,
    },
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Jump to context",
      },
      { "<leader>uC", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter Context" },
    },
  },

  -- Better % navigate and highlight matching words
  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
}
