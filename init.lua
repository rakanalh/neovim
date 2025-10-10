-- Load Neovide configuration if running in Neovide
require("config.neovide")

-- Preserve SSH_AUTH_SOCK environment variable for Git operations
if vim.fn.getenv("SSH_AUTH_SOCK") ~= vim.NIL then
  vim.env.SSH_AUTH_SOCK = vim.fn.getenv("SSH_AUTH_SOCK")
end

-- Startup behavior: Open Obsidian daily note and neotree (must be in init.lua to catch VimEnter)
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("obsidian_startup", { clear = true }),
  callback = function()
    -- Only run if no arguments were passed (not opening a specific file)
    if vim.fn.argc() == 0 then
      -- Wait for plugins to load
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          vim.schedule(function()
            -- Set Obsidian vault as working directory
            vim.cmd("tcd ~/Documents/Obsidian/Desktop")
            -- Mark tab with project path so <leader>pp doesn't override it
            vim.api.nvim_tabpage_set_var(0, "project_path", vim.fn.expand("~/Documents/Obsidian/Desktop"))
            -- Open today's daily note with template
            vim.cmd("ObsidianToday")
            -- Open neotree in left sidebar (will use the tcd path as root)
            vim.cmd("Neotree position=left filesystem")
          end)
        end,
      })
    end
  end,
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
