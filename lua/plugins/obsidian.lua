-- Obsidian vault integration
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    priority = 100,
    opts = {
      -- Enable UI with custom checkbox rendering
      ui = {
        enable = true,
        checkbox = {
          order = { " ", "x" },
        },
      },

      workspaces = {
        {
          name = "Desktop",
          path = "~/Documents/Obsidian/Desktop",
        },
        {
          name = "Mobile",
          path = "~/Documents/Obsidian/Mobile",
        },
        {
          name = "Trading",
          path = "~/Documents/Obsidian/Trading",
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
      },

      -- Optional: completion settings
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          -- gf to follow links
          vim.keymap.set("n", "gf", function()
            if require("obsidian").util.cursor_on_markdown_link() then
              return "<cmd>ObsidianFollowLink<cr>"
            else
              return "gf"
            end
          end, { buffer = true, expr = true })

          -- Toggle checkbox
          vim.keymap.set("n", "<leader>ch", function()
            return require("obsidian").util.toggle_checkbox()
          end, { buffer = true })

          -- Smart action on enter
          vim.keymap.set("n", "<cr>", function()
            return require("obsidian").util.smart_action()
          end, { buffer = true, expr = true })
        end,
      })
    end,
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "New Note" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>",       desc = "Today's Daily Note" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>",   desc = "Yesterday's Daily Note" },
      { "<leader>om", "<cmd>ObsidianTomorrow<cr>",    desc = "Tomorrow's Daily Note" },
      { "<leader>od", "<cmd>ObsidianDailies<cr>",     desc = "Daily Notes Picker" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>",      desc = "Search Notes" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   desc = "Show Backlinks" },
      { "<leader>oT", "<cmd>ObsidianTemplate<cr>",    desc = "Insert Template" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>",       desc = "Show Links" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "Open in Obsidian App" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch Notes" },
      { "<leader>or", "<cmd>ObsidianRename<cr>",      desc = "Rename Note" },
      { "<leader>ow", "<cmd>ObsidianWorkspace<cr>",   desc = "Switch Workspace" },
    },
  },
}
