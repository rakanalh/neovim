-- Solidity-specific plugins and configuration
return {
  -- Solidity treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "solidity" })
    end,
  },

  -- Solidity LSP support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solidity = {
          cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
          filetypes = { "solidity" },
          root_dir = require("lspconfig.util").find_git_ancestor,
          single_file_support = true,
        },
      },
    },
  },

  -- Extend mason-tool-installer with Solidity tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "solidity", -- nomicfoundation-solidity-language-server
      })
    end,
  },

  -- Extend conform.nvim with Solidity formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        solidity = { "forge_fmt" },
      },
      formatters = {
        forge_fmt = {
          command = "forge",
          args = { "fmt", "--raw", "-" },
          stdin = true,
        },
      },
    },
  },

  -- Extend nvim-lint with Solidity linter
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        solidity = { "solhint" },
      },
    },
  },
}
