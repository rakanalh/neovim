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
            -- Open agenda view on the right side (with delay to ensure plugin is loaded)
            vim.defer_fn(function()
              if vim.fn.exists(":AgendaView") > 0 then
                vim.cmd("AgendaView")
                -- Limit AgendaView to 20% of window width
                local total_width = vim.o.columns
                local agenda_width = math.floor(total_width * 0.2)
                local agenda_win = vim.api.nvim_get_current_win()
                vim.api.nvim_win_set_width(agenda_win, agenda_width)

                -- Maintain AgendaView width when layout changes
                vim.api.nvim_create_autocmd({"WinResized", "VimResized"}, {
                  group = vim.api.nvim_create_augroup("agenda_width", { clear = true }),
                  callback = function()
                    if vim.api.nvim_win_is_valid(agenda_win) then
                      local new_total = vim.o.columns
                      local new_agenda_width = math.floor(new_total * 0.2)
                      vim.api.nvim_win_set_width(agenda_win, new_agenda_width)
                    end
                  end,
                })

                -- Open HabitView below AgendaView
                if vim.fn.exists(":HabitView") > 0 then
                  vim.cmd("HabitView")
                end

                -- Focus back to ObsidianToday (center window)
                vim.cmd("wincmd h")

                -- Split horizontally to open Inbox.md below ObsidianToday (only affects center column)
                vim.cmd("split Inbox.md")
                -- Focus back to ObsidianToday (top center window)
                vim.cmd("wincmd k")
              end
            end, 500)
          end)
        end,
      })
    end
  end,
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
