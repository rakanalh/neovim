-- Load Neovide configuration if running in Neovide
require("config.neovide")

-- Preserve SSH_AUTH_SOCK environment variable for Git operations
if vim.fn.getenv("SSH_AUTH_SOCK") ~= vim.NIL then
  vim.env.SSH_AUTH_SOCK = vim.fn.getenv("SSH_AUTH_SOCK")
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
