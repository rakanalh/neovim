return {
  -- Focus.nvim - Automatic window resizing and focus management
  {
    "nvim-focus/focus.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      local focus = require("focus")

      -- Calculate widths for 80%/10%/10% split
      local function calculate_widths()
        local total_width = vim.o.columns
        local focused_width = math.floor(total_width * 0.8)
        local unfocused_width = math.floor(total_width * 0.1)
        return focused_width, unfocused_width
      end

      local focused_width, unfocused_width = calculate_widths()

      focus.setup({
        enable = true, -- Enable plugin (autocmds will be created)
        commands = true,
        autoresize = {
          enable = true,
          width = focused_width,
          height = 0,
          minwidth = unfocused_width,
          minheight = 0,
        },
        ui = {
          number = false,
          relativenumber = false,
          hybridnumber = false,
          absolutenumber_unfocussed = false,
          cursorline = false,
          cursorcolumn = false,
          colorcolumn = {
            enable = false,
          },
          signcolumn = false,
          winhighlight = false,
        },
      })

      -- Start with focus mode disabled
      vim.g.focus_disable = true
    end,
    keys = {
      {
        "<leader>wo",
        function()
          -- Recalculate widths on toggle
          local total_width = vim.o.columns
          local focused_width = math.floor(total_width * 0.8)
          local unfocused_width = math.floor(total_width * 0.1)

          -- Update focus.nvim config
          local focus = require("focus")
          focus.config.autoresize.width = focused_width
          focus.config.autoresize.minwidth = unfocused_width

          -- Toggle focus
          focus.focus_toggle()
        end,
        desc = "Toggle Focus Mode",
      },
      {
        "<leader>wO",
        "<C-W>o",
        desc = "Close Other Windows",
        remap = true,
      },
    },
  },
}
