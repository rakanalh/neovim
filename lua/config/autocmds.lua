-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- SSH Agent check command
vim.api.nvim_create_user_command("SSHCheck", function()
  local ssh_sock = vim.env.SSH_AUTH_SOCK
  if ssh_sock and ssh_sock ~= "" then
    vim.notify("SSH_AUTH_SOCK is set: " .. ssh_sock, vim.log.levels.INFO)
    -- Test SSH agent connection
    local result = vim.fn.system("ssh-add -l")
    if vim.v.shell_error == 0 then
      vim.notify("SSH Agent is working!\n" .. result, vim.log.levels.INFO)
    else
      vim.notify("SSH Agent is not accessible or has no keys", vim.log.levels.WARN)
    end
  else
    vim.notify("SSH_AUTH_SOCK is not set!", vim.log.levels.ERROR)
  end
end, { desc = "Check SSH Agent status" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("resize_splits", {}),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("last_loc", {}),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", {}),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "grug-far",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
    "lazy",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("man_unlisted", {}),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("wrap_spell", {}),
  pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("json_conceal", {}),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", {}),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Custom tabline to show project names instead of buffer names
_G.custom_tabline = function()
  local s = ""
  local current_tab = vim.api.nvim_get_current_tabpage()

  for i = 1, vim.fn.tabpagenr("$") do
    local tab = vim.api.nvim_list_tabpages()[i]
    local is_current = tab == current_tab

    -- Get project path if it exists
    local ok, project_path = pcall(vim.api.nvim_tabpage_get_var, tab, "project_path")
    local label

    if ok and project_path then
      -- Extract project name from path (last directory component)
      label = vim.fn.fnamemodify(project_path, ":t")
    else
      -- Fallback to buffer name
      local winnr = vim.api.nvim_tabpage_get_win(tab)
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname ~= "" then
        label = vim.fn.fnamemodify(bufname, ":t")
      else
        label = "[No Name]"
      end
    end

    -- Check if any buffer in this tab is modified
    local modified = false
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_option(buf, "modified") then
        modified = true
        break
      end
    end

    -- Add spacing before tab
    s = s .. "%#TabLineFill# "

    -- Build tab label with proper highlighting
    if is_current then
      s = s .. "%#TabLineSel#"
      -- Add padding for current tab
      s = s .. "  " .. i .. ": " .. label
      if modified then
        s = s .. " ●" -- Use a dot for modified indicator
      end
      s = s .. "  "
    else
      s = s .. "%#TabLine#"
      -- Normal padding for inactive tabs
      s = s .. " " .. i .. ": " .. label
      if modified then
        s = s .. "%#TabLineModified# ●%#TabLine#" -- Highlight modified indicator
      end
      s = s .. " "
    end

    -- Add spacing after tab
    s = s .. "%#TabLineFill# "
  end

  -- Fill the rest of the line
  s = s .. "%#TabLineFill#%=" -- Right align any status info

  return s
end

-- Set custom tabline
vim.opt.tabline = "%!v:lua.custom_tabline()"
