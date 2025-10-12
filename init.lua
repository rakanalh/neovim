-- Load Neovide configuration if running in Neovide
require("config.neovide")

-- Preserve SSH_AUTH_SOCK environment variable for Git operations
if vim.fn.getenv("SSH_AUTH_SOCK") ~= vim.NIL then
  vim.env.SSH_AUTH_SOCK = vim.fn.getenv("SSH_AUTH_SOCK")
end

-- Obsidian configuration
vim.g.obsidian_vault_path = "~/Documents/Obsidian/Desktop"

-- Setup Obsidian workspace layout
local function setup_obsidian_layout()
  -- Set Obsidian vault as working directory
  vim.cmd("tcd " .. vim.g.obsidian_vault_path)
  -- Mark tab with project path so <leader>pp doesn't override it
  vim.api.nvim_tabpage_set_var(0, "project_path", vim.fn.expand(vim.g.obsidian_vault_path))

  -- Open today's daily note with template
  vim.cmd("ObsidianToday")

  -- Open neotree in left sidebar
  vim.cmd("Neotree position=left filesystem")

  -- Open agenda and habit views (edgy will manage positioning)
  vim.defer_fn(function()
    if vim.fn.exists(":AgendaView") > 0 then
      vim.cmd("AgendaView")
    end
    if vim.fn.exists(":HabitView") > 0 then
      vim.cmd("HabitView")
    end

    -- Focus back to the main center window before creating splits
    vim.cmd("wincmd h")

    -- Open Inbox.md below ObsidianToday
    vim.cmd("split Inbox.md")

    -- Get current window width (center area width)
    local center_width = vim.api.nvim_win_get_width(0)

    -- Open Habits.md to the right of Inbox (50/50 split)
    vim.cmd("vsplit Habits.md")

    -- Set Habits.md to 50% width
    vim.api.nvim_win_set_width(0, math.floor(center_width / 2))

    -- Store window handles for Inbox and Habits
    local habits_win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd h") -- Move to Inbox
    local inbox_win = vim.api.nvim_get_current_win()

    -- Maintain 50/50 split when layout changes
    vim.api.nvim_create_autocmd({ "WinResized", "WinClosed", "WinNew" }, {
      group = vim.api.nvim_create_augroup("obsidian_layout_maintain", { clear = true }),
      callback = function()
        if vim.api.nvim_win_is_valid(inbox_win) and vim.api.nvim_win_is_valid(habits_win) then
          local inbox_width = vim.api.nvim_win_get_width(inbox_win)
          local habits_width = vim.api.nvim_win_get_width(habits_win)
          local total = inbox_width + habits_width
          local target = math.floor(total / 2)

          -- Only adjust if difference is significant
          if math.abs(habits_width - target) > 2 then
            vim.api.nvim_win_set_width(habits_win, target)
          end
        end
      end,
    })

    -- Focus back to ObsidianToday (top center window)
    vim.cmd("wincmd k")
    vim.cmd("wincmd h")
  end, 500)
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
          vim.schedule(setup_obsidian_layout)
        end,
      })
    end
  end,
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
