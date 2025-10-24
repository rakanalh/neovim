-- Context-aware which-key labels for localleader (<leader>m)
-- This file sets up buffer-local group names that change based on the current filetype

-- Helper function to check if buffer is in Octo review context
local function is_octo_context()
  local maps = vim.api.nvim_buf_get_keymap(0, "n")
  for _, map in ipairs(maps) do
    if map.lhs and (map.lhs:match(" m%]") or map.lhs:match("<Space>m%]")) then
      return true
    end
  end
  return false
end

-- Helper function to register Octo which-key groups
local function register_octo_groups(bufnr)
  local wk = require("which-key")
  wk.add({
    { "<leader>m",  group = "Octo Actions", buffer = bufnr },
    { "<leader>ma", group = "Assignee",     buffer = bufnr },
    { "<leader>mc", group = "Comment",      buffer = bufnr },
    { "<leader>ml", group = "Label",        buffer = bufnr },
    { "<leader>mi", group = "Issue",        buffer = bufnr },
    { "<leader>mr", group = "React",        buffer = bufnr },
    { "<leader>ms", group = "Suggestion",   buffer = bufnr },
    { "<leader>mp", group = "PR",           buffer = bufnr },
    { "<leader>mv", group = "Review",       buffer = bufnr },
    { "<leader>mg", group = "Goto Issue",   buffer = bufnr },
  })
end

-- Generic hook to unmap language-specific keymaps after LSP attaches in Octo context
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.schedule(function()
      local bufnr = args.buf

      -- Check for Octo mappings
      local maps = vim.api.nvim_buf_get_keymap(bufnr, "n")
      local has_octo_map = false
      for _, map in ipairs(maps) do
        if map.lhs and (map.lhs:match(" m%]") or map.lhs:match("<Space>m%]")) then
          has_octo_map = true
          break
        end
      end

      if has_octo_map then
        -- We're in Octo context - unmap all non-Octo <leader>m keymaps
        vim.defer_fn(function()
          local current_maps = vim.api.nvim_buf_get_keymap(bufnr, "n")

          for _, map in ipairs(current_maps) do
            if map.lhs and map.lhs:match("^ m") then
              local desc = map.desc or ""
              -- Keep only Octo keymaps (everything else goes)
              local is_octo = desc:match("[Rr]eview") or desc:match("[Cc]omment")
                  or desc:match("[Ss]uggestion") or desc:match("PR")
                  or desc:match("viewer") or desc:match("file")
                  or map.lhs:match("^ m%]$") or map.lhs:match("^ m%[$")

              if not is_octo then
                pcall(vim.keymap.del, "n", map.lhs, { buffer = bufnr })
              end
            end
          end
        end, 200)
      end
    end)
  end,
  desc = "Unmap language keymaps in Octo context after LSP attach",
})

-- Rust buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.schedule(function()
      local bufnr = vim.fn.bufnr()

      -- Guard: Only register once per buffer
      if vim.b.localleader_setup then
        return
      end
      vim.b.localleader_setup = true

      if is_octo_context() then
        register_octo_groups(bufnr)
      else
        local wk = require("which-key")
        wk.add({
          { "<leader>m",  group = "Rust",   buffer = bufnr },
          { "<leader>mt", group = "Tests",  buffer = bufnr },
          { "<leader>mc", group = "Crates", buffer = bufnr },
        })
      end
    end)
  end,
  desc = "Setup Rust localleader labels",
})

-- Python buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.schedule(function()
      local bufnr = vim.fn.bufnr()

      -- Guard: Only register once per buffer
      if vim.b.localleader_setup then
        return
      end
      vim.b.localleader_setup = true

      if is_octo_context() then
        register_octo_groups(bufnr)
      else
        local wk = require("which-key")
        wk.add({
          { "<leader>m",  group = "Python Actions", buffer = bufnr },
          { "<leader>mt", group = "Tests",          buffer = bufnr },
          { "<leader>ms", group = "Send to REPL",   buffer = bufnr },
        })
      end
    end)
  end,
  desc = "Setup Python localleader labels",
})

-- Lua buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.schedule(function()
      local bufnr = vim.fn.bufnr()

      -- Guard: Only register once per buffer
      if vim.b.localleader_setup then
        return
      end
      vim.b.localleader_setup = true

      if is_octo_context() then
        register_octo_groups(bufnr)
      else
        local wk = require("which-key")
        wk.add({
          { "<leader>m",  group = "Lua Actions", buffer = bufnr },
          { "<leader>ml", group = "Execute Lua", buffer = bufnr },
        })
      end
    end)
  end,
  desc = "Setup Lua localleader labels",
})

-- Cargo.toml buffers (for crates.nvim)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "toml",
  callback = function()
    vim.schedule(function()
      local filename = vim.fn.expand("%:t")
      if filename == "Cargo.toml" then
        local bufnr = vim.fn.bufnr()

        -- Guard: Only register once per buffer
        if vim.b.localleader_setup then
          return
        end
        vim.b.localleader_setup = true

        if is_octo_context() then
          register_octo_groups(bufnr)
        else
          local wk = require("which-key")
          wk.add({
            { "<leader>m",  group = "Cargo.toml Actions", buffer = bufnr },
            { "<leader>mc", group = "Crates",             buffer = bufnr },
          })
        end
      end
    end)
  end,
  desc = "Setup Cargo.toml localleader labels",
})

-- Octo buffers (GitHub PR/Issue)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "octo",
  callback = function()
    vim.schedule(function()
      local bufnr = vim.fn.bufnr()

      -- Guard: Only register once per buffer
      if vim.b.localleader_setup then
        return
      end
      vim.b.localleader_setup = true

      register_octo_groups(bufnr)
    end)
  end,
  desc = "Setup Octo localleader labels",
})

-- Grug-far buffers (Search/Replace)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "grug-far",
  callback = function()
    vim.schedule(function()
      local bufnr = vim.fn.bufnr()

      -- Guard: Only register once per buffer
      if vim.b.localleader_setup then
        return
      end
      vim.b.localleader_setup = true

      local wk = require("which-key")
      wk.add({
        { "<leader>m",  group = "Grug-far Actions", buffer = bufnr },
        { "<leader>mr", desc = "Replace",           buffer = bufnr },
        { "<leader>mq", desc = "Quickfix List",     buffer = bufnr },
        { "<leader>ms", desc = "Sync Locations",    buffer = bufnr },
        { "<leader>ml", desc = "Sync Line",         buffer = bufnr },
        { "<leader>mc", desc = "Close",             buffer = bufnr },
        { "<leader>mh", desc = "History",           buffer = bufnr },
        { "<leader>ma", desc = "Add to History",    buffer = bufnr },
        { "<leader>mf", desc = "Refresh",           buffer = bufnr },
        { "<leader>mo", desc = "Open Location",     buffer = bufnr },
        { "<leader>mb", desc = "Abort",             buffer = bufnr },
      })
    end)
  end,
  desc = "Setup Grug-far localleader labels",
})
