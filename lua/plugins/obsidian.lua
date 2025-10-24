-- Obsidian vault integration
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    -- Load on markdown files OR on VeryLazy (for startup layout)
    event = "VeryLazy",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- Disable UI rendering - let render-markdown handle it
      ui = {
        enable = false,
      },

      workspaces = {
        {
          name = "Desktop",
          path = vim.g.obsidian_vault_path,
        },
        {
          name = "Mobile",
          path = "~/Documents/Obsidian/Mobile",
        },
        {
          name = "Work",
          path = "~/Documents/Obsidian/Work",
        },
      },

      -- Optional: customize note ID generation
      note_id_func = function(title)
        -- Create note IDs based on title
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- Generate random ID for untitled notes
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,

      -- Optional: customize daily notes
      daily_notes = {
        folder = "Daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "Daily Note Template.md",
        workdays_only = false,
      },

      -- Templates folder
      templates = {
        folder = "_templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- Completion settings
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
    },
    init = function()
      -- Override obsidian's default <CR> keymap to be completion-aware
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.md",
        callback = function(ev)
          -- Wait a bit for obsidian's autocmds to run first
          vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(ev.buf) then
              return
            end

            -- Override the <CR> mapping in normal mode to check for completion
            vim.keymap.set("n", "<cr>", function()
              local cmp_ok, cmp = pcall(require, "cmp")
              if cmp_ok and cmp.visible() then
                return cmp.confirm({ select = true })
              end
              -- Call obsidian's smart_action only if not completing
              return require("obsidian").util.smart_action()
            end, { buffer = ev.buf, expr = true, desc = "Obsidian Smart Action (cmp-aware)" })

            -- In insert mode, prioritize completion over obsidian
            vim.keymap.set("i", "<cr>", function()
              local cmp_ok, cmp = pcall(require, "cmp")
              if cmp_ok and cmp.visible() then
                return cmp.confirm({ select = true })
              end
              return "<cr>"
            end, { buffer = ev.buf, expr = true, desc = "Confirm completion" })
          end, 10)
        end,
      })
    end,
    keys = {
      { "<leader>mn", "<cmd>ObsidianNew<cr>",         desc = "New Note",             ft = "markdown" },
      { "<leader>mt", "<cmd>ObsidianToday<cr>",       desc = "Today's Daily Note",   ft = "markdown" },
      { "<leader>my", "<cmd>ObsidianYesterday<cr>",   desc = "Yesterday's Daily Note", ft = "markdown" },
      { "<leader>mm", "<cmd>ObsidianTomorrow<cr>",    desc = "Tomorrow's Daily Note", ft = "markdown" },
      { "<leader>md", "<cmd>ObsidianDailies<cr>",     desc = "Daily Notes Picker",   ft = "markdown" },
      { "<leader>ms", "<cmd>ObsidianSearch<cr>",      desc = "Search Notes",         ft = "markdown" },
      { "<leader>mb", "<cmd>ObsidianBacklinks<cr>",   desc = "Show Backlinks",       ft = "markdown" },
      { "<leader>mT", "<cmd>ObsidianTemplate<cr>",    desc = "Insert Template",      ft = "markdown" },
      { "<leader>ml", "<cmd>ObsidianLinks<cr>",       desc = "Show Links",           ft = "markdown" },
      { "<leader>mo", "<cmd>ObsidianOpen<cr>",        desc = "Open in Obsidian App", ft = "markdown" },
      { "<leader>mq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch Notes",   ft = "markdown" },
      { "<leader>mr", "<cmd>ObsidianRename<cr>",      desc = "Rename Note",          ft = "markdown" },
      { "<leader>mw", "<cmd>ObsidianWorkspace<cr>",   desc = "Switch Workspace",     ft = "markdown" },
    },
  },
}
