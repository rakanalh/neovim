return {
  -- Navic for current code context (used by barbecue.nvim)
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("lazyvim.util").lsp.on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("lazyvim.config").icons.kinds,
        lazy_update_context = true,
      }
    end,
  },

  -- Barbecue - VS Code-like breadcrumbs
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      theme = "auto",
      show_dirname = true,
      show_basename = true,
      show_modified = true,
      show_navic = true,
      exclude_filetypes = {
        "netrw",
        "toggleterm",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "alpha",
      },
    },
  },

  -- File operations with LSP support (rename, move, etc.)
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },

  -- Show code actions as virtual text
  {
    "kosayoda/nvim-lightbulb",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      priority = 100,
      hide_in_unfocused_buffer = true,
      sign = {
        enabled = false,
      },
      virtual_text = {
        enabled = true,
        text = "💡",
        pos = "eol", -- Show at end of line
        hl = "LightBulbVirtualText",
      },
      autocmd = {
        enabled = true,
        pattern = { "*" },
        events = { "CursorHold", "CursorHoldI" },
      },
    },
  },

  -- Mason-lspconfig integration
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = false, -- mason-tool-installer handles this
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "kosayoda/nvim-lightbulb",
    },
    opts = function(_, opts)
      -- Override LazyVim's default LSP keymaps to prevent conflicts
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- Remove LazyVim's default <leader>ss mapping (document symbols)
      -- We use it for searching buffer lines instead
      for i = #keys, 1, -1 do
        if keys[i][1] == "<leader>ss" then
          table.remove(keys, i)
        end
      end

      -- Language-specific LSP servers
      local servers = {
        -- Bash
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command)",
            },
          },
        },
        -- Docker
        dockerls = {
          settings = {
            docker = {
              languageserver = {
                formatter = {
                  ignoreMultilineInstructions = true,
                },
              },
            },
          },
        },
        docker_compose_language_service = {
          filetypes = { "yaml.docker-compose" },
        },
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
              },
            },
          },
        },
        -- TypeScript/JavaScript
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Markdown
        marksman = {
          filetypes = { "markdown", "markdown.mdx" },
        },

        -- TOML (Taplo)
        taplo = {
          root_dir = function(fname, bufnr)
            -- Handle both fname and bufnr arguments
            local filepath = type(fname) == "string" and fname or vim.api.nvim_buf_get_name(fname)
            -- Exclude cargo registry to prevent spam warnings
            if filepath:match("%.cargo/registry") then
              return nil
            end
            return require("lspconfig.util").find_git_ancestor(filepath)
          end,
        },
      }

      -- Merge with existing servers from LazyVim
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, servers)

      -- Set custom capabilities for file operations
      opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      })

      return opts
    end,
  },

  -- Mason package manager for LSP servers
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Language-specific tools are now managed in langs/*.lua files
      },
    },
  },

  -- Mason integration for installing formatters and linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local tools = {
        -- General tools
        "yamllint",
        "jsonlint",
        "sql-formatter",
        "taplo", -- TOML formatter

        -- Bash
        "bash-language-server",
        "shfmt",
        "shellcheck",

        -- Docker
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint",

        -- Lua
        "lua-language-server",
        "stylua",
        "luacheck",

        -- Python
        "pyright",
        "black",
        "isort",
        "ruff",
        "pylint",
        "mypy",

        -- TypeScript/JavaScript
        "typescript-language-server",
        "prettier",
        "eslint_d",

        -- Rust
        "rustfmt",

        -- Markdown
        "marksman",
        "markdownlint",
      }

      return {
        ensure_installed = tools,
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      }
    end,
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
}
