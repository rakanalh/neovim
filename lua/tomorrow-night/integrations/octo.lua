local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Core color groups
  hl(0, "OctoGreen", { fg = colors.green })
  hl(0, "OctoRed", { fg = colors.red })
  hl(0, "OctoPurple", { fg = colors.violet })
  hl(0, "OctoYellow", { fg = colors.yellow })
  hl(0, "OctoBlue", { fg = colors.blue })
  hl(0, "OctoGrey", { fg = colors.subtext1 })

  -- Float variants
  local float_bg = opts.transparent_background and "NONE" or colors.mantle
  hl(0, "OctoGreenFloat", { fg = colors.green, bg = float_bg })
  hl(0, "OctoRedFloat", { fg = colors.red, bg = float_bg })
  hl(0, "OctoPurpleFloat", { fg = colors.violet, bg = float_bg })
  hl(0, "OctoYellowFloat", { fg = colors.yellow, bg = float_bg })
  hl(0, "OctoBlueFloat", { fg = colors.blue, bg = float_bg })
  hl(0, "OctoGreyFloat", { fg = colors.subtext1, bg = float_bg })

  -- Bubble variants (colored backgrounds with contrasting text)
  hl(0, "OctoBubbleGreen", { fg = colors.base, bg = colors.green })
  hl(0, "OctoBubbleRed", { fg = colors.base, bg = colors.red })
  hl(0, "OctoBubblePurple", { fg = colors.text, bg = colors.violet })
  hl(0, "OctoBubbleYellow", { fg = colors.base, bg = colors.yellow })
  hl(0, "OctoBubbleBlue", { fg = colors.base, bg = colors.blue })
  hl(0, "OctoBubbleGrey", { fg = colors.text, bg = colors.subtext1 })

  -- Bubble delimiters
  hl(0, "OctoBubbleDelimiterGreen", { fg = colors.green })
  hl(0, "OctoBubbleDelimiterRed", { fg = colors.red })
  hl(0, "OctoBubbleDelimiterPurple", { fg = colors.violet })
  hl(0, "OctoBubbleDelimiterYellow", { fg = colors.yellow })
  hl(0, "OctoBubbleDelimiterBlue", { fg = colors.blue })
  hl(0, "OctoBubbleDelimiterGrey", { fg = colors.subtext1 })

  -- File panel
  hl(0, "OctoFilePanelTitle", { fg = colors.blue, bold = true })
  hl(0, "OctoFilePanelCounter", { fg = colors.violet, bold = true })
  hl(0, "OctoFilePanelFileName", { fg = colors.text })
  hl(0, "OctoFilePanelSelectedFile", { fg = colors.yellow })
  hl(0, "OctoFilePanelPath", { fg = colors.subtext1 })

  -- UI elements
  hl(0, "OctoNormalFloat", { fg = colors.text })
  hl(0, "OctoViewer", { fg = colors.base, bg = colors.blue })
  hl(0, "OctoEditable", { bg = float_bg })
  hl(0, "OctoStrikethrough", { fg = colors.subtext1, strikethrough = true })
  hl(0, "OctoUnderline", { fg = colors.text, underline = true })

  -- Status indicators
  hl(0, "OctoStatusAdded", { fg = colors.green })
  hl(0, "OctoStatusUntracked", { fg = colors.green })
  hl(0, "OctoStatusModified", { fg = colors.blue })
  hl(0, "OctoStatusRenamed", { fg = colors.blue })
  hl(0, "OctoStatusCopied", { fg = colors.blue })
  hl(0, "OctoStatusTypeChange", { fg = colors.blue })
  hl(0, "OctoStatusUnmerged", { fg = colors.blue })
  hl(0, "OctoStatusUnknown", { fg = colors.yellow })
  hl(0, "OctoStatusDeleted", { fg = colors.red })
  hl(0, "OctoStatusBroken", { fg = colors.red })

  -- Issue/PR elements
  hl(0, "OctoDirty", { fg = colors.red })
  hl(0, "OctoIssueId", { fg = colors.text })
  hl(0, "OctoIssueTitle", { fg = colors.violet })
  hl(0, "OctoFloat", { fg = colors.text })
  hl(0, "OctoTimelineItemHeading", { fg = colors.subtext1 })
  hl(0, "OctoTimelineMarker", { fg = colors.violet })
  hl(0, "OctoSymbol", { fg = colors.subtext1 })
  hl(0, "OctoDate", { fg = colors.subtext1 })

  -- Details
  hl(0, "OctoDetailsLabel", { fg = colors.blue, bold = true })
  hl(0, "OctoDetailsValue", { fg = colors.violet })
  hl(0, "OctoMissingDetails", { fg = colors.subtext1 })

  -- Bubbles and reactions
  hl(0, "OctoEmpty", { fg = colors.text })
  hl(0, "OctoBubble", { fg = colors.text })
  hl(0, "OctoUser", { link = "OctoBubble" })
  hl(0, "OctoUserViewer", { link = "OctoViewer" })
  hl(0, "OctoReaction", { link = "OctoBubble" })
  hl(0, "OctoReactionViewer", { link = "OctoViewer" })

  -- Test results
  hl(0, "OctoPassingTest", { fg = colors.green })
  hl(0, "OctoFailingTest", { fg = colors.red })

  -- PR stats
  hl(0, "OctoPullAdditions", { fg = colors.green })
  hl(0, "OctoPullDeletions", { fg = colors.red })
  hl(0, "OctoDiffstatAdditions", { fg = colors.green })
  hl(0, "OctoDiffstatDeletions", { fg = colors.red })
  hl(0, "OctoDiffstatNeutral", { fg = colors.subtext1 })

  -- State indicators (text-only)
  hl(0, "OctoStateOpen", { fg = colors.green })
  hl(0, "OctoStateClosed", { fg = colors.red })
  hl(0, "OctoStateCompleted", { fg = colors.violet })
  hl(0, "OctoStateNotPlanned", { fg = colors.subtext1 })
  hl(0, "OctoStateDraft", { fg = colors.subtext1 })
  hl(0, "OctoStateMerged", { fg = colors.violet })
  hl(0, "OctoStatePending", { fg = colors.yellow })
  hl(0, "OctoStateApproved", { fg = colors.green })
  hl(0, "OctoStateChangesRequested", { fg = colors.red })
  hl(0, "OctoStateDismissed", { fg = colors.red })
  hl(0, "OctoStateCommented", { fg = colors.blue })
  hl(0, "OctoStateSubmitted", { fg = colors.green })

  -- State bubbles (colored backgrounds)
  hl(0, "OctoStateOpenBubble", { link = "OctoBubbleGreen" })
  hl(0, "OctoStateClosedBubble", { link = "OctoBubbleRed" })
  hl(0, "OctoStateMergedBubble", { link = "OctoBubblePurple" })
  hl(0, "OctoStatePendingBubble", { link = "OctoBubbleYellow" })
  hl(0, "OctoStateApprovedBubble", { link = "OctoBubbleGreen" })
  hl(0, "OctoStateChangesRequestedBubble", { link = "OctoBubbleRed" })
  hl(0, "OctoStateDismissedBubble", { link = "OctoBubbleRed" })
  hl(0, "OctoStateCommentedBubble", { link = "OctoBubbleBlue" })
  hl(0, "OctoStateSubmittedBubble", { link = "OctoBubbleGreen" })

  -- State floats
  hl(0, "OctoStateOpenFloat", { link = "OctoGreenFloat" })
  hl(0, "OctoStateClosedFloat", { link = "OctoRedFloat" })
  hl(0, "OctoStateMergedFloat", { link = "OctoPurpleFloat" })
  hl(0, "OctoStateDraftFloat", { link = "OctoGreyFloat" })

  -- Window elements
  hl(0, "OctoNormal", { link = "Normal" })
  hl(0, "OctoCursorLine", { link = "CursorLine" })
  hl(0, "OctoWinSeparator", { link = "WinSeparator" })
  hl(0, "OctoSignColumn", { link = "Normal" })
  hl(0, "OctoStatusColumn", { link = "SignColumn" })
  hl(0, "OctoStatusLine", { link = "StatusLine" })
  hl(0, "OctoStatusLineNC", { link = "StatusLineNC" })
  hl(0, "OctoEndOfBuffer", { link = "EndOfBuffer" })
end

return M
