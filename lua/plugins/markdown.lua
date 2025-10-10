-- Markdown-specific plugins and configuration
return {
  -- Render markdown in Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading = {
        enabled = true,
        sign = false,
        icons = {},
        above = '▄',
        below = '▀',
      },
      code = {
        enabled = true,
        render_modes = false,
        sign = true,
        conceal_delimiters = true,
        language = true,
        position = 'left',
        language_icon = false,
        language_name = false,
        language_info = false,
        language_pad = 0,
        disable_background = { 'diff' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'hide',
        language_border = '█',
        language_left = '',
        language_right = '',
        above = '▄',
        below = '▀',
        inline = true,
        inline_left = '',
        inline_right = '',
        inline_pad = 0,
        highlight = 'RenderMarkdownCode',
        highlight_info = 'RenderMarkdownCodeInfo',
        highlight_language = nil,
        highlight_border = 'RenderMarkdownCodeBorder',
        highlight_fallback = 'RenderMarkdownCodeFallback',
        highlight_inline = 'RenderMarkdownCodeInline',
        style = 'full',
      },
      bullet = {
        bullet = {
          enabled = true,
          render_modes = false,
          icons = { '●', '○', '◆', '◇' },
          ordered_icons = function(ctx)
            local value = vim.trim(ctx.value)
            local index = tonumber(value:sub(1, #value - 1))
            return ('%d.'):format(index > 1 and index or ctx.index)
          end,
          left_pad = 0,
          right_pad = 0,
          highlight = 'RenderMarkdownBullet',
          scope_highlight = {},
          scope_priority = nil,
        },
      },
      checkbox = {
        enabled = true,
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
          scope_highlight = nil,
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
          scope_highlight = nil,
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        },
      },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  -- Bullets.vim - Automatic bullet list handling
  {
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    init = function()
      -- Enable for these filetypes
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
      -- Use checkbox markers: space, dash (in-progress), X (done)
      vim.g.bullets_checkbox_markers = " -X"
      -- Enable auto-wrapping for bullets
      vim.g.bullets_set_mappings = 1
      -- Enable nested checkboxes
      vim.g.bullets_nested_checkboxes = 1
      -- Delete empty bullets
      vim.g.bullets_delete_last_bullet_if_empty = 1
      -- Disable bullets checkbox toggle (we use custom)
      vim.g.bullets_checkbox_toggle_mapping = ""
    end,
    config = function()
      -- Custom checkbox cycling: [ ] -> [-] -> [x] -> [ ]
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "<leader>ch", function()
            local line = vim.api.nvim_get_current_line()
            local new_line
            if line:match("%[%s%]") then
              new_line = line:gsub("%[%s%]", "[%-]", 1)
            elseif line:match("%[%-]") then
              new_line = line:gsub("%[%-%]", "[x]", 1)
            elseif line:match("%[x%]") or line:match("%[X%]") then
              new_line = line:gsub("%[[xX]%]", "[ ]", 1)
            else
              return
            end
            vim.api.nvim_set_current_line(new_line)
          end, { buffer = true, desc = "Cycle checkbox" })
        end,
      })
    end,
  },

  -- Markdown table mode - auto-format tables
  {
    "Kicamon/markdown-table-mode.nvim",
    ft = { "markdown" },
    opts = {
      options = {
        insert = true,       -- Auto-format when typing |
        insert_leave = true, -- Auto-format when leaving insert mode
      },
      filetype = {
        "*.md",
      },
    },
  },

  -- Markdown agenda and habit tracker
  {
    "rakanalh/md-agenda.nvim",
    branch = "splits",
    lazy = false, -- Load immediately for startup
    priority = 50,
    config = function()
      local palette = require("tomorrow-night.palette")

      require("md-agenda").setup({
        agendaFiles = {
          "~/Documents/Obsidian/Desktop",
          "~/Documents/Obsidian/Mobile",
          "~/Documents/Obsidian/Trading",
          "~/Documents/Obsidian/Work",
        },
        agendaViewSplitOrientation = "vertical",
        habitViewSplitOrientation = "horizontal",
        agendaViewPageItems = 10,
        remindDeadlineInDays = 30,
        remindScheduledInDays = 10,

        -- Tomorrow Night theme colors
        titleColor = palette.cyan,          -- Dates in calm cyan
        todoTypeColor = palette.yellow,     -- TODO items stand out in yellow
        habitTypeColor = palette.blue,      -- HABIT items in blue
        habitTitleColor = palette.violet,   -- Habit titles in violet
        infoTypeColor = palette.green,      -- INFO items in green
        dueTypeColor = palette.orange,      -- DUE items in orange (warning)
        doneTypeColor = palette.green,      -- DONE items in green (success)
        cancelledTypeColor = palette.red,   -- CANCELLED items in red
        completionColor = palette.green,    -- Completion percentage in green
        scheduledTimeColor = palette.yellow,-- Scheduled time in yellow
        deadlineTimeColor = palette.orange, -- Deadline time in orange
        tagColor = palette.subtext1,        -- Tags in muted gray

        -- Habit view colors (solid symbols need same fg+bg)
        habitScheduledColor = palette.orange,    -- Scheduled habits in orange
        habitDoneColor = palette.green,          -- Done habits in green
        habitProgressColor = palette.yellow,     -- Progress in yellow
        habitPastScheduledColor = palette.red,   -- Past scheduled in red
        habitFreeTimeColor = palette.blue,       -- Free time in blue
        habitNotDoneColor = palette.red,         -- Not done in red
        habitDeadlineColor = palette.subtext1,   -- Deadline in gray
        habitTodayColor = palette.cyan,          -- Today marker in cyan
      })
    end,
    keys = {
      { "<leader>oaa",  "<cmd>AgendaView<cr>",    desc = "Agenda View" },
      { "<leader>oah",  "<cmd>HabitView<cr>",     desc = "Habit View" },
      { "<leader>oatt", "<cmd>TaskScheduled<cr>", desc = "Task Scheduled" },
      { "<leader>oatd", "<cmd>TaskDeadline<cr>",  desc = "Task Deadline" },
    },
  },

}
