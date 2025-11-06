local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- File panel
  hl(0, "DiffviewFilePanelTitle", { fg = colors.blue, bold = true })
  hl(0, "DiffviewFilePanelCounter", { fg = colors.violet, bold = true })
  hl(0, "DiffviewFilePanelFileName", { fg = colors.text })
  hl(0, "DiffviewFilePanelRootPath", { fg = colors.blue, bold = true })
  hl(0, "DiffviewFilePanelPath", { fg = colors.subtext1 })
  hl(0, "DiffviewFilePanelInsertions", { fg = colors.green }) -- Additions in GREEN
  hl(0, "DiffviewFilePanelDeletions", { fg = colors.red })    -- Deletions in RED
  hl(0, "DiffviewFilePanelConflicts", { fg = colors.yellow })
  hl(0, "DiffviewFilePanelSelected", { fg = colors.blue, bold = true })

  -- Status types
  hl(0, "DiffviewStatusAdded", { fg = colors.green })
  hl(0, "DiffviewStatusUntracked", { fg = colors.green })
  hl(0, "DiffviewStatusModified", { fg = colors.yellow })
  hl(0, "DiffviewStatusRenamed", { fg = colors.yellow })
  hl(0, "DiffviewStatusCopied", { fg = colors.yellow })
  hl(0, "DiffviewStatusTypeChange", { fg = colors.yellow })
  hl(0, "DiffviewStatusUnmerged", { fg = colors.orange })
  hl(0, "DiffviewStatusUnknown", { fg = colors.red })
  hl(0, "DiffviewStatusDeleted", { fg = colors.red })
  hl(0, "DiffviewStatusBroken", { fg = colors.red })
  hl(0, "DiffviewStatusIgnored", { fg = colors.subtext1 })

  -- Diff content (GitHub-style: changed lines appear as add/delete with darker exact changes)
  hl(0, "DiffviewDiffAdd", { bg = colors.diff_add_bg, fg = "NONE" })             -- Added lines with GREEN bg
  hl(0, "DiffviewDiffDelete", { fg = colors.red, bg = colors.diff_delete_bg })   -- Deleted lines with RED bg
  hl(0, "DiffviewDiffChange", { bg = colors.diff_add_bg, fg = "NONE" })          -- Changed lines use GREEN bg (right side)
  hl(0, "DiffviewDiffText", { bg = colors.diff_add_text, fg = "NONE", bold = true })  -- Exact changed text in darker green, NO BLUE!
  hl(0, "DiffviewDiffAddAsDelete", { fg = colors.red, bg = colors.diff_delete_bg })

  -- Dim variants
  hl(0, "DiffviewDiffDeleteDim", { fg = colors.overlay0 })

  -- Git references
  hl(0, "DiffviewReference", { fg = colors.violet })
  hl(0, "DiffviewHash", { fg = colors.cyan })
  hl(0, "DiffviewReflogSelector", { fg = colors.violet })

  -- Folder
  hl(0, "DiffviewFolderName", { fg = colors.blue })
  hl(0, "DiffviewFolderSign", { fg = colors.violet })

  -- UI elements
  hl(0, "DiffviewNormal", { fg = colors.text, bg = colors.base })
  hl(0, "DiffviewCursorLine", { bg = colors.surface0 })
  hl(0, "DiffviewSignColumn", { fg = colors.surface1, bg = colors.base })
  hl(0, "DiffviewStatusLine", { fg = colors.text, bg = colors.mantle })
  hl(0, "DiffviewStatusLineNC", { fg = colors.surface1, bg = colors.mantle })
  hl(0, "DiffviewEndOfBuffer", { fg = colors.base })
  hl(0, "DiffviewWinSeparator", { fg = colors.surface0 })

  -- Misc
  hl(0, "DiffviewDim1", { fg = colors.subtext1 })
  hl(0, "DiffviewPrimary", { fg = colors.blue })
  hl(0, "DiffviewSecondary", { fg = colors.orange })
end

return M
