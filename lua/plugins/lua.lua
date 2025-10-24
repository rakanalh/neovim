-- Lua-specific tooling and keymaps
return {
  -- Neodev disabled in favor of lazydev.nvim (provided by LazyVim)
  {
    "folke/neodev.nvim",
    enabled = false,
  },

  -- Additional Lua keymaps for Neovim config development
  {
    "nvim-lua/plenary.nvim",
    keys = {
      {
        "<localleader>x",
        function()
          -- Source current lua file
          vim.cmd("source %")
          vim.notify("Sourced " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
        end,
        desc = "Source Current Lua File",
        ft = "lua",
      },
      {
        "<localleader>ll",
        function()
          -- Run current line as Lua
          local line = vim.api.nvim_get_current_line()
          local ok, result = pcall(loadstring(line))
          if ok then
            vim.notify("Executed: " .. line, vim.log.levels.INFO)
            if result then
              print(vim.inspect(result))
            end
          else
            vim.notify("Error: " .. tostring(result), vim.log.levels.ERROR)
          end
        end,
        desc = "Execute Current Line as Lua",
        ft = "lua",
      },
      {
        "<localleader>lb",
        function()
          -- Run entire buffer as Lua
          local ok, err = pcall(function()
            vim.cmd("source %")
          end)
          if ok then
            vim.notify("Executed buffer successfully", vim.log.levels.INFO)
          else
            vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
          end
        end,
        desc = "Execute Buffer as Lua",
        ft = "lua",
      },
    },
  },
}
