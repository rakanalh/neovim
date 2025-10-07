-- Rust-specific plugins and configuration
return {
  -- Disable rust-analyzer in nvim-lspconfig (rustaceanvim handles it)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = { enabled = false },
      },
    },
  },

  -- Rustaceanvim - Better Rust development (successor to rust-tools)
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = function()
      -- Get absolute path to workspace for target-dir
      local workspace = vim.fn.getcwd()
      local target_dir = workspace .. "/target/rust-analyzer"

      return {
        tools = {
          hover_actions = {
            auto_focus = false,
          },
        },
        server = {
          cmd = function()
            local ra = vim.fn.exepath("rust-analyzer")
            if ra ~= "" then
              return { ra }
            end
          end,
          cmd_env = {
            SKIP_GUEST_BUILD = "1",
          },
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp('codeAction') end,
              { buffer = bufnr, desc = "Code Action (Rust)" })
            vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp('debuggables') end,
              { buffer = bufnr, desc = "Rust Debuggables" })
            vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp('runnables') end,
              { buffer = bufnr, desc = "Rust Runnables" })
            vim.keymap.set("n", "<leader>re", function() vim.cmd.RustLsp('expandMacro') end,
              { buffer = bufnr, desc = "Expand Macro (Rust)" })
            vim.keymap.set("n", "<leader>rc", function() vim.cmd.RustLsp('openCargo') end,
              { buffer = bufnr, desc = "Open Cargo.toml" })
            vim.keymap.set("n", "<leader>rp", function() vim.cmd.RustLsp('parentModule') end,
              { buffer = bufnr, desc = "Parent Module (Rust)" })
            vim.keymap.set("n", "K", function() vim.cmd.RustLsp('hover', 'actions') end,
              { buffer = bufnr, desc = "Hover Actions (Rust)" })
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = false,
                buildScripts = {
                  enable = false,
                  invocationStrategy = "once",
                  rebuildOnSave = false,
                },
                extraEnv = {
                  SKIP_GUEST_BUILD = "1"
                }
              },
              checkOnSave = {
                enable = true,
                allFeatures = false,
                command = "clippy",
                extraArgs = { "--no-deps", "--target-dir", target_dir },
                extraEnv = {
                  SKIP_GUEST_BUILD = "1"
                }
              },
              cachePriming = {
                enable = false,
              },
              procMacro = {
                enable = true,
                attributes = {
                  enable = true,
                },
              },
              inlayHints = {
                bindingModeHints = {
                  enable = false,
                },
                chainingHints = {
                  enable = true,
                },
                closingBraceHints = {
                  enable = true,
                  minLines = 25,
                },
                closureReturnTypeHints = {
                  enable = "never",
                },
                lifetimeElisionHints = {
                  enable = "never",
                  useParameterNames = false,
                },
                maxLength = 25,
                parameterHints = {
                  enable = true,
                },
                reborrowHints = {
                  enable = "never",
                },
                renderColons = true,
                typeHints = {
                  enable = true,
                },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },

  -- Extend conform.nvim with Rust formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },

  -- Extend mason-tool-installer with Rust tools
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- rust-analyzer is managed by rustaceanvim (install via: rustup component add rust-analyzer)
        "rustfmt",
      })
    end,
  },
}
