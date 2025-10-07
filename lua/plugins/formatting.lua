-- Code formatting and linting
return {
  -- Conform.nvim - Modern formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = function(_, opts)
      local formatters_by_ft = {
        -- General
        toml = { "taplo" },
        sql = { "sql_formatter" },
        ["_"] = { "trim_whitespace" },

        -- Bash
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        -- Lua
        lua = { "stylua" },

        -- Python
        python = { "black", "isort" },

        -- TypeScript/JavaScript
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        graphql = { "prettier" },
        handlebars = { "prettier" },

        -- Rust
        rust = { "rustfmt" },

        -- Markdown
        markdown = { "prettier", "markdownlint" },
      }

      -- Merge with existing formatters
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, formatters_by_ft)

      opts.format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable for certain filetypes
        local ignore_filetypes = { "sql", "java" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- Disable for large files
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if line_count > 5000 then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end

      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        shfmt = {
          prepend_args = { "-i", "2" }, -- 2 spaces indent
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        prettier = {
          prepend_args = { "--tab-width", "2" },
        },
      })

      return opts
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      -- Commands to toggle format on save
      vim.api.nvim_create_user_command("ConformDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("ConformEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },

  -- nvim-lint - Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      local linters_by_ft = {
        -- General
        yaml = { "yamllint" },
        json = { "jsonlint" },
        toml = { "taplo" },

        -- Bash
        sh = { "shellcheck" },
        bash = { "shellcheck" },

        -- Docker
        dockerfile = { "hadolint" },

        -- Lua
        lua = { "luacheck" },

        -- Python
        python = { "pylint", "mypy" },

        -- TypeScript/JavaScript
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },

        -- Markdown
        markdown = { "markdownlint" },
      }

      -- Configure luacheck for Neovim
      local luacheck = lint.linters.luacheck
      luacheck.args = {
        "--globals",
        "vim",
        "lvim",
        "reload",
        "--",
      }

      lint.linters_by_ft = linters_by_ft

      -- Create autocmd for linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if the buffer is attached to an LSP client
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients > 0 then
            -- Wrap in pcall to handle missing linters gracefully
            pcall(lint.try_lint)
          end
        end,
      })

      -- Manual lint command
      vim.api.nvim_create_user_command("Lint", function()
        local ok, err = pcall(lint.try_lint)
        if not ok then
          vim.notify("Linting failed: " .. tostring(err), vim.log.levels.WARN)
        end
      end, { desc = "Trigger linting for current buffer" })
    end,
  },
}