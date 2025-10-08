-- Obsidian vault integration
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
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
      },

      -- Optional: completion settings
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- Optional: mappings
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
    },
  },
}
