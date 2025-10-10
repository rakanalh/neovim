-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Better up/down
map({ "n", "x" }, "gsj", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "gsk", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })

-- Cycle scroll position: zt -> zz -> zb
local scroll_state = 1
map("n", "<C-l>", function()
  local cmds = { "zt", "zz", "zb" }
  vim.cmd("normal! " .. cmds[scroll_state])
  scroll_state = (scroll_state % 3) + 1
end, { desc = "Cycle Scroll Position" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- find files in current file's directory
map("n", "<leader>fd", function()
  require("snacks").picker.files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Find Files (Current Dir)" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
  require("lazyvim.util.format").format({ force = true })
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- toggle options
map("n", "<leader>uf", function() require("lazyvim.util.format").toggle() end, { desc = "Toggle Auto Format (Global)" })
map("n", "<leader>uF", function() require("lazyvim.util.format").toggle(true) end,
  { desc = "Toggle Auto Format (Buffer)" })
map("n", "<leader>us", function() require("lazyvim.util").toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() require("lazyvim.util").toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>uL", function() require("lazyvim.util").toggle("relativenumber") end,
  { desc = "Toggle Relative Line Numbers" })
map("n", "<leader>ul", function() require("lazyvim.util").toggle.number() end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", function() require("lazyvim.util").toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() require("lazyvim.util").toggle("conceallevel", false, { 0, conceallevel }) end,
  { desc = "Toggle Conceal" })
if vim.lsp.inlay_hint then
  map("n", "<leader>uh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
    { desc = "Toggle Inlay Hints" })
end

-- Commented out - using Neogit instead of lazygit
-- map("n", "<leader>gg", function() require("lazyvim.util").terminal({ "lazygit" }, { cwd = require("lazyvim.util").root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (Root Dir)" })
-- map("n", "<leader>gG", function() require("lazyvim.util").terminal({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (cwd)" })
-- map("n", "<leader>gc", function() require("snacks").picker.git_log() end, { desc = "Git Commits" }) -- Conflicts with Neogit commit
map("n", "<leader>gb", function() require("snacks").picker.git_branches() end, { desc = "Git Branches" })
map("n", "<leader>gs", function() require("snacks").picker.git_status() end, { desc = "Git Status" })

-- quit with confirmation
map("n", "<leader>qq", function()
  local choice = vim.fn.confirm("Do you really want to quit?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd("qa")
  end
end, { desc = "Quit All (with confirmation)" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>w0", "<cmd>bdelete<cr>", { desc = "Close Current Buffer" })
map("n", "<leader>w1", "<C-W>o", { desc = "Close Other Windows", remap = true })

-- tabs with momentary visibility
map("n", "<leader><tab>l", function()
  vim.opt.showtabline = 2
  vim.cmd("tablast")
  vim.defer_fn(function() vim.opt.showtabline = 0 end, 2000)
end, { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", function()
  vim.opt.showtabline = 2
  vim.cmd("tabfirst")
  vim.defer_fn(function() vim.opt.showtabline = 0 end, 2000)
end, { desc = "First Tab" })
-- Removed - using custom <tab><tab> functionality below instead
map("n", "<leader><tab>]", function()
  vim.opt.showtabline = 2
  vim.cmd("tabnext")
  vim.defer_fn(function() vim.opt.showtabline = 0 end, 2000)
end, { desc = "Next Tab" })
map("n", "<leader><tab>d", function()
  local tab_count = vim.fn.tabpagenr('$')
  if tab_count == 1 then
    -- If only one tab, show dashboard
    vim.cmd("enew")
    vim.cmd("Dashboard")
  else
    -- Otherwise close the tab normally
    vim.cmd("tabclose")
  end
end, { desc = "Close Tab" })
map("n", "<leader><tab>[", function()
  vim.opt.showtabline = 2
  vim.cmd("tabprevious")
  vim.defer_fn(function() vim.opt.showtabline = 0 end, 2000)
end, { desc = "Previous Tab" })

-- Override tab keybinding to show tabs momentarily instead of creating new tab
map("n", "<leader><tab><tab>", function()
  -- Temporarily show tabs for 3 seconds
  vim.opt.showtabline = 2
  vim.defer_fn(function()
    vim.opt.showtabline = 0
  end, 3000)
end, { desc = "Show Tabs Momentarily" })
