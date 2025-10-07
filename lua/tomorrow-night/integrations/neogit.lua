local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Neogit highlights
  hl(0, "NeogitBranch", { fg = colors.violet })
  hl(0, "NeogitRemote", { fg = colors.violet })

  -- Headers
  hl(0, "NeogitHunkHeader", { fg = colors.blue, bg = colors.surface0, bold = true })
  hl(0, "NeogitHunkHeaderHighlight", { fg = colors.blue, bg = colors.surface1, bold = true })
  hl(0, "NeogitDiffContext", { fg = colors.text, bg = colors.base })
  hl(0, "NeogitDiffContextHighlight", { bg = colors.surface0 })

  -- Diff colors
  hl(0, "NeogitDiffAdd", { fg = colors.green, bg = colors.surface0 })
  hl(0, "NeogitDiffAddHighlight", { fg = colors.green, bg = colors.surface1 })
  hl(0, "NeogitDiffDelete", { fg = colors.red, bg = colors.surface0 })
  hl(0, "NeogitDiffDeleteHighlight", { fg = colors.red, bg = colors.surface1 })

  -- Section headers should be BLUE and BOLD
  hl(0, "NeogitSectionHeader", { fg = colors.blue, bold = true })
  hl(0, "NeogitUnstagedchanges", { fg = colors.blue, bold = true })
  hl(0, "NeogitStagedchanges", { fg = colors.blue, bold = true })
  hl(0, "NeogitStashes", { fg = colors.blue, bold = true })
  hl(0, "NeogitUnmergedInto", { fg = colors.blue, bold = true })
  hl(0, "NeogitUnpulledFrom", { fg = colors.blue, bold = true })
  hl(0, "NeogitUnpushedTo", { fg = colors.blue, bold = true })
  hl(0, "NeogitRecentcommits", { fg = colors.blue, bold = true })
  hl(0, "NeogitUntrackedfiles", { fg = colors.blue, bold = true })
  hl(0, "NeogitUnmergedchanges", { fg = colors.blue, bold = true })
  hl(0, "NeogitUnpulledchanges", { fg = colors.blue, bold = true })
  hl(0, "NeogitUnpushedchanges", { fg = colors.blue, bold = true })

  -- File status - All filenames in white (no background colors!)
  hl(0, "NeogitChangeModified", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeAdded", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeDeleted", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeRenamed", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeCopied", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeUpdated", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeNewFile", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeBothModified", { fg = colors.text, bg = "NONE" })

  -- Untracked files MUST be white (not "None" which Neogit sets by default)
  -- This overrides Neogit's { fg = "None" } setting
  hl(0, "NeogitChangeUntrackeduntracked", { fg = colors.text, bg = "NONE", italic = false })
  hl(0, "NeogitUntracked", { fg = colors.text, bg = "NONE" })

  -- Also set all other untracked variants to white
  hl(0, "NeogitChangeUntrackedunstaged", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeUntrackedstaged", { fg = colors.text, bg = "NONE" })

  -- Override all the linked untracked groups
  hl(0, "NeogitChangeMuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeAuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeNuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeDuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeCuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeUuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeRuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeDDuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeUUuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeAAuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeDUuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeUDuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeAUuntracked", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitChangeUAuntracked", { fg = colors.text, bg = "NONE" })

  -- Commit view
  hl(0, "NeogitCommitViewHeader", { fg = colors.blue, bg = colors.surface0, bold = true })
  hl(0, "NeogitCommitViewDescription", { fg = colors.text })
  hl(0, "NeogitCommitViewAuthor", { fg = colors.green })
  hl(0, "NeogitCommitViewDate", { fg = colors.cyan })
  hl(0, "NeogitCommitViewHash", { fg = colors.violet })

  -- Status buffer
  hl(0, "NeogitObjectId", { fg = colors.violet })
  hl(0, "NeogitStash", { fg = colors.violet })
  hl(0, "NeogitFold", { fg = colors.overlay0 })
  hl(0, "NeogitRebaseDone", { fg = colors.green })
  hl(0, "NeogitTagName", { fg = colors.yellow })
  hl(0, "NeogitTagDistance", { fg = colors.cyan })

  -- Popup
  hl(0, "NeogitPopupSectionTitle", { fg = colors.blue, bold = true })
  hl(0, "NeogitPopupBranchName", { fg = colors.violet })
  hl(0, "NeogitPopupBold", { bold = true })
  hl(0, "NeogitPopupSwitchKey", { fg = colors.orange })
  hl(0, "NeogitPopupSwitchEnabled", { fg = colors.green })
  hl(0, "NeogitPopupSwitchDisabled", { fg = colors.red })
  hl(0, "NeogitPopupOptionKey", { fg = colors.orange })
  hl(0, "NeogitPopupOptionEnabled", { fg = colors.green })
  hl(0, "NeogitPopupOptionDisabled", { fg = colors.red })
  hl(0, "NeogitPopupConfigKey", { fg = colors.orange })
  hl(0, "NeogitPopupConfigEnabled", { fg = colors.green })
  hl(0, "NeogitPopupConfigDisabled", { fg = colors.red })
  hl(0, "NeogitPopupActionKey", { fg = colors.orange })
  hl(0, "NeogitPopupActionEnabled", { fg = colors.text })
  hl(0, "NeogitPopupActionDisabled", { fg = colors.surface2 })

  -- File status in git status (short forms)
  hl(0, "NeogitChangeM", { fg = colors.blue, bold = true })  -- Modified (blue for consistency)
  hl(0, "NeogitChangeA", { fg = colors.green, bold = true }) -- Added
  hl(0, "NeogitChangeD", { fg = colors.red, bold = true })   -- Deleted
  hl(0, "NeogitChangeR", { fg = colors.violet, bold = true }) -- Renamed
  hl(0, "NeogitChangeC", { fg = colors.cyan, bold = true })  -- Copied
  hl(0, "NeogitChangeU", { fg = colors.orange, bold = true }) -- Updated but unmerged
  hl(0, "NeogitChangeN", { fg = colors.green, bold = true })  -- New file

  -- Graph
  hl(0, "NeogitGraphAuthor", { fg = colors.green })
  hl(0, "NeogitGraphBlue", { fg = colors.blue })
  hl(0, "NeogitGraphGreen", { fg = colors.green })
  hl(0, "NeogitGraphRed", { fg = colors.red })
  hl(0, "NeogitGraphOrange", { fg = colors.orange })
  hl(0, "NeogitGraphViolet", { fg = colors.violet })
  hl(0, "NeogitGraphCyan", { fg = colors.cyan })
  hl(0, "NeogitGraphYellow", { fg = colors.yellow })
  hl(0, "NeogitGraphGray", { fg = colors.overlay0 })
  hl(0, "NeogitGraphBoldBlue", { fg = colors.blue, bold = true })
  hl(0, "NeogitGraphBoldGreen", { fg = colors.green, bold = true })
  hl(0, "NeogitGraphBoldRed", { fg = colors.red, bold = true })
  hl(0, "NeogitGraphBoldOrange", { fg = colors.orange, bold = true })
  hl(0, "NeogitGraphBoldViolet", { fg = colors.violet, bold = true })
  hl(0, "NeogitGraphBoldCyan", { fg = colors.cyan, bold = true })
  hl(0, "NeogitGraphBoldYellow", { fg = colors.yellow, bold = true })
  hl(0, "NeogitGraphBoldGray", { fg = colors.overlay0, bold = true })

  -- Signs
  hl(0, "NeogitSignAdded", { fg = colors.green })
  hl(0, "NeogitSignModified", { fg = colors.blue })  -- Blue for consistency
  hl(0, "NeogitSignDeleted", { fg = colors.red })

  -- Floating windows
  hl(0, "NeogitFloatHeader", { fg = colors.blue, bg = colors.surface0, bold = true })
  hl(0, "NeogitFloatHeaderHighlight", { fg = colors.blue, bg = colors.surface1, bold = true })

  -- Command history
  hl(0, "NeogitCommandText", { fg = colors.text })
  hl(0, "NeogitCommandTime", { fg = colors.cyan })
  hl(0, "NeogitCommandCodeNormal", { fg = colors.green })
  hl(0, "NeogitCommandCodeError", { fg = colors.red })

  -- Cursor
  hl(0, "NeogitCursorLine", { bg = colors.surface0 })

  -- File paths should be white
  hl(0, "NeogitFilePath", { fg = colors.text, bg = "NONE" })
  hl(0, "NeogitFilePathHighlight", { fg = colors.text, bg = "NONE" })

  -- References
  hl(0, "NeogitReflogHeader", { fg = colors.blue, bold = true })
  hl(0, "NeogitReflogSelector", { fg = colors.violet })

  -- Merge conflicts
  hl(0, "NeogitMergeConflict", { fg = colors.orange, bold = true })

  -- Notification
  hl(0, "NeogitNotificationInfo", { fg = colors.blue })
  hl(0, "NeogitNotificationWarning", { fg = colors.yellow })
  hl(0, "NeogitNotificationError", { fg = colors.red })
end

return M