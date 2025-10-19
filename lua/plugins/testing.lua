-- Testing framework - Neotest
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- Language-specific adapters
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-python",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-rust") {
            args = { "--no-capture" },
            dap_adapter = "lldb",
          },
          require("neotest-python") {
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
          },
        },
        status = {
          enabled = true,
          virtual_text = true,
          signs = true,
        },
        output = {
          enabled = true,
          open_on_run = "short",
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            output = "o",
            run = "r",
            short = "O",
            stop = "u",
            watch = "w",
          },
        },
        icons = {
          passed = "",
          running = "",
          failed = "",
          skipped = "",
          unknown = "",
          watching = "",
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
    keys = {
      {
        "<localleader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
        ft = { "rust", "python" },
      },
      {
        "<localleader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run All Tests in File",
        ft = { "rust", "python" },
      },
      {
        "<localleader>ts",
        function()
          require("neotest").run.run(vim.fn.getcwd())
        end,
        desc = "Run Test Suite",
        ft = { "rust", "python" },
      },
      {
        "<localleader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Show Test Output",
        ft = { "rust", "python" },
      },
      {
        "<localleader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Test Output Panel",
        ft = { "rust", "python" },
      },
      {
        "<localleader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop Nearest Test",
        ft = { "rust", "python" },
      },
      {
        "<localleader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch Tests",
        ft = { "rust", "python" },
      },
      {
        "<localleader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
        ft = { "rust", "python" },
      },
      {
        "<localleader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last Test",
        ft = { "rust", "python" },
      },
      {
        "<localleader>tu",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Test Summary",
        ft = { "rust", "python" },
      },
    },
  },
}
