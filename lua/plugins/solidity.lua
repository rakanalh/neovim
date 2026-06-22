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
          single_file_support = true,
          on_attach = function(client)
            -- Disable LSP formatting; conform.nvim handles it with forge_fmt
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          handlers = {
            ["window/showMessageRequest"] = function(_, params)
              if not params.actions or #params.actions == 0 then
                return vim.NIL
              end
              return vim.lsp.handlers["window/showMessageRequest"](_, params)
            end,
          },
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
        "solidity-ls", -- nomicfoundation-solidity-language-server
        "solhint",
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
        solidity = {},
      },
    },
  },
}
