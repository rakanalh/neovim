-- Python-specific tooling and keymaps
return {
  -- Python REPL integration
  {
    "Vigemus/iron.nvim",
    ft = "python",
    config = function()
      local iron = require("iron.core")
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { "python3" },
              format = require("iron.fts.common").bracketed_paste,
            },
          },
          repl_open_cmd = require("iron.view").split.vertical.botright(50),
        },
        keymaps = {
          send_motion = "<localleader>sc",
          visual_send = "<localleader>sc",
          send_file = "<localleader>sf",
          send_line = "<localleader>sl",
          send_until_cursor = "<localleader>su",
          send_mark = "<localleader>sm",
          cr = "<localleader><cr>",
          interrupt = "<localleader>s<space>",
          exit = "<localleader>sq",
          clear = "<localleader>sr",
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      })
    end,
    keys = {
      {
        "<localleader>i",
        "<cmd>IronRepl<cr>",
        desc = "Start Python REPL",
        ft = "python",
      },
      {
        "<localleader>r",
        "<cmd>IronRestart<cr>",
        desc = "Restart REPL",
        ft = "python",
      },
      {
        "<localleader>F",
        "<cmd>IronFocus<cr>",
        desc = "Focus REPL",
        ft = "python",
      },
      {
        "<localleader>h",
        "<cmd>IronHide<cr>",
        desc = "Hide REPL",
        ft = "python",
      },
    },
  },
}
