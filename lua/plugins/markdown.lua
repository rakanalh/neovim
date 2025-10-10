-- Markdown-specific plugins and configuration
return {
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
      -- Use only standard markdown checkboxes (compatible with Obsidian rendering)
      vim.g.bullets_checkbox_markers = " X"
      -- Enable auto-wrapping for bullets
      vim.g.bullets_set_mappings = 1
      -- Enable nested checkboxes
      vim.g.bullets_nested_checkboxes = 1
      -- Delete empty bullets
      vim.g.bullets_delete_last_bullet_if_empty = 1
    end,
  },
}
