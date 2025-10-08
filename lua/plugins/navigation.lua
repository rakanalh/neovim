-- Navigation and file management plugins
return {
  -- Flash.nvim - Enhanced navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm", -- Use only lowercase letters
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
        mode = "exact",
      },
      jump = {
        pos = "start",
      },
      label = {
        uppercase = false,
        rainbow = {
          enabled = false, -- No rainbow colors
        },
      },
      highlight = {
        backdrop = false,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
      prompt = {
        enabled = false, -- No animated prompt
      },
      modes = {
        search = {
          enabled = true,
          highlight = { backdrop = false },
        },
        char = {
          enabled = false,          -- Disable for normal f/F/t/T
          multi_line = true,
          label = { exclude = "" }, -- Don't exclude any keys
          autohide = false,
          jump_labels = true,
          keys = {}, -- Use all available label keys
        },
      },
    },
    init = function()
      -- Shared 2-char line jump logic
      local function format(opts)
        return {
          { opts.match.label1, "FlashMatch" },
          { opts.match.label2, "FlashLabel" },
        }
      end

      _G.flash_two_char_line_jump = function(forward)
        local Flash = require("flash")
        Flash.jump({
          search = { mode = "search", max_length = 0, forward = forward },
          label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
          pattern = "^",
          action = function(match, state)
            state:hide()
            Flash.jump({
              search = { max_length = 0 },
              highlight = { matches = false },
              label = { format = format },
              matcher = function(win)
                return vim.tbl_filter(function(m)
                  return m.label == match.label and m.win == win
                end, state.results)
              end,
              labeler = function(matches)
                for _, m in ipairs(matches) do
                  m.label = m.label2
                end
              end,
            })
          end,
          labeler = function(matches, state)
            local labels = state:labels()
            for m, match in ipairs(matches) do
              match.label1 = labels[math.floor((m - 1) / #labels) + 1]
              match.label2 = labels[(m - 1) % #labels + 1]
              match.label = match.label1
            end
          end,
        })
      end
    end,
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
      -- Doom-like line jumping with 2-char labels
      { "gj", mode = { "n", "x", "o" }, function() flash_two_char_line_jump(true) end, desc = "Jump to line" },
      { "gk", mode = { "n", "x", "o" }, function() flash_two_char_line_jump(false) end, desc = "Jump to line (backwards)" },
      {
        "gw",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            pattern = ".",
            search = {
              wrap = true,
              multi_window = true,
              mode = function(str)
                return "\\<" .. str
              end,
            },
          })
        end,
        desc = "Jump to word"
      },
    },
  },

  -- Harpoon2 - Quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup({
        settings = {
          save_on_toggle = false,
          sync_on_ui_close = false,
          key = function()
            return vim.uv.cwd()
          end,
        },
      })
      -- REQUIRED

      -- Basic keymaps
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon Add File" })
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

      -- Navigation keymaps
      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon File 1" })
      vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = "Harpoon File 2" })
      vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = "Harpoon File 3" })
      vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = "Harpoon File 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon Previous" })
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon Next" })

      -- Telescope integration (optional)
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end

      vim.keymap.set("n", "<leader>hf", function() toggle_telescope(harpoon:list()) end, { desc = "Harpoon Telescope" })
    end,
  },

  -- oil.nvim - Edit filesystem like a buffer
  {
    "stevearc/oil.nvim",
    opts = {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      default_file_explorer = true,

      -- Columns to display
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },

      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },

      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },

      -- Skip the confirmation popup for simple operations
      skip_confirm_for_simple_edits = false,

      -- Selecting a new/moved/renamed file will prompt you to save changes first
      prompt_save_on_select_new_entry = true,

      -- Oil will automatically delete hidden buffers after this delay
      cleanup_delay_ms = 2000,

      -- Keymaps in oil buffer
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },

      -- Set to false to disable all default keymaps
      use_default_keymaps = true,

      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
        sort = {
          -- sort order can be "asc" or "desc"
          { "type", "asc" },
          { "name", "asc" },
        },
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
      require("oil").setup(opts)
      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      -- Open oil in float
      vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open oil float" })
    end,
  },

  -- ToggleTerm - Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      on_create = function(t)
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.foldexpr = ""
      end,
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = false, -- No shading/dimming
      shading_factor = 1,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      winbar = {
        enabled = false,
      },
    },
    keys = {
      { "<C-\\>",     desc = "Toggle terminal" },
      { "<leader>tt", "<cmd>ToggleTerm<cr>",                              desc = "Toggle terminal" },
      { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>",   desc = "Vertical terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",              desc = "Float terminal" },
      {
        "<leader>tg",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
              border = "double",
            },
            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
            on_close = function(term)
              vim.cmd("startinsert!")
            end,
          })
          lazygit:toggle()
        end,
        desc = "Lazygit"
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Terminal mode mappings
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
    end,
  },
}
