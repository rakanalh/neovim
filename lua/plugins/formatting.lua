-- Code formatting and linting

-- Configuration: Directories to skip linting
local LINT_IGNORE_DIRS = {
  "Documents/Obsidian",
  -- Add more patterns here as needed
  -- "path/to/ignore",
}

return {
  -- Conform.nvim - Extend LazyVim's formatting configuration
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Extend formatters_by_ft with our additional formatters
      local formatters_by_ft = {
        -- General
        toml = { "taplo" },
        sql = { "sql_formatter" },
        ["_"] = { "trim_whitespace" },

        -- Bash
        bash = { "shfmt" },
        zsh = { "shfmt" },

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

      -- Merge with LazyVim's formatters
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, formatters_by_ft)

      -- Configure formatter options
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
    keys = {
      -- Override LazyVim's <leader>cF to format current buffer instead of injected langs
      {
        "<leader>cF",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    init = function()
      -- Add custom commands for toggling autoformat
      vim.api.nvim_create_user_command("ConformDisable", function(args)
        if args.bang then
          vim.b.autoformat = false
        else
          vim.g.autoformat = false
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("ConformEnable", function()
        vim.b.autoformat = true
        vim.g.autoformat = true
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },

  -- nvim-lint - Extend LazyVim's linting configuration
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Extend linters_by_ft
      linters_by_ft = {
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
      },
      -- Configure luacheck for Neovim
      linters = {
        luacheck = {
          args = {
            "--globals",
            "vim",
            "lvim",
            "reload",
            "--",
          },
        },
      },
    },
    config = function(_, opts)
      local lint = require("lint")

      -- Apply LazyVim's config setup for linters
      for name, linter in pairs(opts.linters or {}) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      -- Custom lint function with directory filtering and LSP check
      local function custom_lint()
        -- Skip linting for ignored directories
        local file_path = vim.api.nvim_buf_get_name(0)
        for _, pattern in ipairs(LINT_IGNORE_DIRS) do
          if file_path:match(pattern) then
            return
          end
        end

        -- Only lint if the buffer is attached to an LSP client
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients > 0 then
          -- Use LazyVim's lint logic with fallback/global linters support
          local M = {}
          function M.lint()
            local names = lint._resolve_linter_by_ft(vim.bo.filetype)
            names = vim.list_extend({}, names)

            -- Add fallback linters
            if #names == 0 then
              vim.list_extend(names, lint.linters_by_ft["_"] or {})
            end

            -- Add global linters
            vim.list_extend(names, lint.linters_by_ft["*"] or {})

            -- Filter out linters that don't exist or don't match conditions
            local ctx = { filename = vim.api.nvim_buf_get_name(0) }
            ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
            names = vim.tbl_filter(function(name)
              local linter = lint.linters[name]
              return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
            end, names)

            if #names > 0 then
              lint.try_lint(names)
            end
          end

          M.lint()
        end
      end

      -- Set up autocmd with custom lint function
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd(opts.events or { "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          vim.schedule(custom_lint)
        end,
      })

      -- Manual lint command
      vim.api.nvim_create_user_command("Lint", function()
        custom_lint()
      end, { desc = "Trigger linting for current buffer" })
    end,
  },
}
