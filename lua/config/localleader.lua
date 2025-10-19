-- Context-aware which-key labels for localleader (<leader>m)
-- This file sets up buffer-local group names that change based on the current filetype

-- Rust buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>m",  group = "Rust Actions", buffer = vim.fn.bufnr() },
      { "<leader>mt", group = "Tests",        buffer = vim.fn.bufnr() },
      { "<leader>mc", group = "Crates",       buffer = vim.fn.bufnr() },
    })
  end,
  desc = "Setup Rust localleader labels",
})

-- Python buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>m",  group = "Python Actions", buffer = vim.fn.bufnr() },
      { "<leader>mt", group = "Tests",          buffer = vim.fn.bufnr() },
      { "<leader>ms", group = "Send to REPL",   buffer = vim.fn.bufnr() },
    })
  end,
  desc = "Setup Python localleader labels",
})

-- Lua buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>m",  group = "Lua Actions", buffer = vim.fn.bufnr() },
      { "<leader>ml", group = "Execute Lua", buffer = vim.fn.bufnr() },
    })
  end,
  desc = "Setup Lua localleader labels",
})

-- Cargo.toml buffers (for crates.nvim)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "toml",
  callback = function()
    -- Only apply if it's a Cargo.toml file
    local filename = vim.fn.expand("%:t")
    if filename == "Cargo.toml" then
      local wk = require("which-key")
      wk.add({
        { "<leader>m",  group = "Cargo.toml Actions", buffer = vim.fn.bufnr() },
        { "<leader>mc", group = "Crates",             buffer = vim.fn.bufnr() },
      })
    end
  end,
  desc = "Setup Cargo.toml localleader labels",
})

-- Octo buffers (GitHub PR/Issue)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "octo",
  callback = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>m",  group = "Octo Actions", buffer = vim.fn.bufnr() },
      { "<leader>ma", group = "Assignee",     buffer = vim.fn.bufnr() },
      { "<leader>mc", group = "Comment",      buffer = vim.fn.bufnr() },
      { "<leader>ml", group = "Label",        buffer = vim.fn.bufnr() },
      { "<leader>mi", group = "Issue",        buffer = vim.fn.bufnr() },
      { "<leader>mr", group = "React",        buffer = vim.fn.bufnr() },
      { "<leader>ms", group = "Suggestion",   buffer = vim.fn.bufnr() },
      { "<leader>mp", group = "PR",           buffer = vim.fn.bufnr() },
      { "<leader>mv", group = "Review",       buffer = vim.fn.bufnr() },
      { "<leader>mg", group = "Goto Issue",   buffer = vim.fn.bufnr() },
    })
  end,
  desc = "Setup Octo localleader labels",
})

-- Grug-far buffers (Search/Replace)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "grug-far",
  callback = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>m",  group = "Grug-far Actions", buffer = vim.fn.bufnr() },
      { "<leader>mr", desc = "Replace",           buffer = vim.fn.bufnr() },
      { "<leader>mq", desc = "Quickfix List",     buffer = vim.fn.bufnr() },
      { "<leader>ms", desc = "Sync Locations",    buffer = vim.fn.bufnr() },
      { "<leader>ml", desc = "Sync Line",         buffer = vim.fn.bufnr() },
      { "<leader>mc", desc = "Close",             buffer = vim.fn.bufnr() },
      { "<leader>mh", desc = "History",           buffer = vim.fn.bufnr() },
      { "<leader>ma", desc = "Add to History",    buffer = vim.fn.bufnr() },
      { "<leader>mf", desc = "Refresh",           buffer = vim.fn.bufnr() },
      { "<leader>mo", desc = "Open Location",     buffer = vim.fn.bufnr() },
      { "<leader>mb", desc = "Abort",             buffer = vim.fn.bufnr() },
    })
  end,
  desc = "Setup Grug-far localleader labels",
})
