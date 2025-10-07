-- Neovide configuration
if vim.g.neovide then
  -- Always use GPG agent's SSH socket in Neovide
  -- This overrides any incorrect SSH_AUTH_SOCK that might be set
  local gpg_sock = vim.fn.system("gpgconf --list-dirs agent-ssh-socket 2>/dev/null"):gsub("%s+", "")

  if gpg_sock ~= "" and vim.fn.filereadable(gpg_sock) == 1 then
    -- Always override to use GPG agent
    vim.env.SSH_AUTH_SOCK = gpg_sock
  end

  -- Disable all animations
  vim.g.neovide_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_position_animation_length = 0

  -- Disable cursor particles effects
  vim.g.neovide_cursor_vfx_mode = ""

  -- Font configuration
  vim.o.guifont = "Fira Code Retina:h10"

  -- Performance settings
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_no_idle = false

  -- Window settings
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_fullscreen = false

  -- Opacity (0.0 to 1.0, 1.0 is opaque)
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_window_blurred = false

  -- Input settings
  vim.g.neovide_input_use_logo = true -- Enable cmd/super key on macOS
  vim.g.neovide_input_macos_alt_is_meta = false
  vim.g.neovide_touch_deadzone = 6.0
  vim.g.neovide_touch_drag_timeout = 0.17

  -- Padding
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  -- Hide mouse when typing
  vim.g.neovide_hide_mouse_when_typing = true

  -- Underline automatic scaling
  vim.g.neovide_underline_stroke_scale = 1.0

  -- Theme
  vim.g.neovide_theme = "auto" -- auto, light, or dark

  -- Confirm quit
  vim.g.neovide_confirm_quit = false

  -- Profiler
  vim.g.neovide_profiler = false

  -- Copy/paste keybindings for Neovide
  vim.keymap.set('n', '<D-s>', ':w<CR>')      -- Save
  vim.keymap.set('v', '<D-c>', '"+y')         -- Copy
  vim.keymap.set('n', '<D-v>', '"+P')         -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P')         -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+')      -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

  -- Dynamic font size adjustment
  vim.keymap.set('n', '<C-=>', function()
    local size = tonumber(vim.o.guifont:match(":h(%d+)"))
    if size then
      vim.o.guifont = vim.o.guifont:gsub(":h%d+", ":h" .. (size + 1))
      vim.notify("Font size: " .. (size + 1))
    end
  end, { desc = "Increase font size" })

  vim.keymap.set('n', '<C-->', function()
    local size = tonumber(vim.o.guifont:match(":h(%d+)"))
    if size and size > 1 then
      vim.o.guifont = vim.o.guifont:gsub(":h%d+", ":h" .. (size - 1))
      vim.notify("Font size: " .. (size - 1))
    end
  end, { desc = "Decrease font size" })

  vim.keymap.set('n', '<C-0>', function()
    vim.o.guifont = "Fira Code Retina:h9"
    vim.notify("Font size reset to 9")
  end, { desc = "Reset font size" })
end

