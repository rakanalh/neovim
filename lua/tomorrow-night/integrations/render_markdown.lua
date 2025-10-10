local M = {}

function M.apply(colors, opts)
  local hl = vim.api.nvim_set_hl

  -- Treesitter markdown heading highlights
  hl(0, "@markup.heading.1.markdown", { fg = colors.blue, bold = true })
  hl(0, "@markup.heading.2.markdown", { fg = colors.cyan, bold = true })
  hl(0, "@markup.heading.3.markdown", { fg = colors.violet, bold = true })
  hl(0, "@markup.heading.4.markdown", { fg = colors.green, bold = true })
  hl(0, "@markup.heading.5.markdown", { fg = colors.orange, bold = true })
  hl(0, "@markup.heading.6.markdown", { fg = colors.lavender, bold = true })

  -- Standard markdown heading highlights (fallback for non-treesitter)
  hl(0, "markdownH1", { link = "@markup.heading.1.markdown" })
  hl(0, "markdownH2", { link = "@markup.heading.2.markdown" })
  hl(0, "markdownH3", { link = "@markup.heading.3.markdown" })
  hl(0, "markdownH4", { link = "@markup.heading.4.markdown" })
  hl(0, "markdownH5", { link = "@markup.heading.5.markdown" })
  hl(0, "markdownH6", { link = "@markup.heading.6.markdown" })

  -- Heading delimiters
  hl(0, "markdownH1Delimiter", { link = "@markup.heading.1.markdown" })
  hl(0, "markdownH2Delimiter", { link = "@markup.heading.2.markdown" })
  hl(0, "markdownH3Delimiter", { link = "@markup.heading.3.markdown" })
  hl(0, "markdownH4Delimiter", { link = "@markup.heading.4.markdown" })
  hl(0, "markdownH5Delimiter", { link = "@markup.heading.5.markdown" })
  hl(0, "markdownH6Delimiter", { link = "@markup.heading.6.markdown" })

  -- RenderMarkdown plugin heading highlights (link to treesitter)
  hl(0, "RenderMarkdownH1", { link = "@markup.heading.1.markdown" })
  hl(0, "RenderMarkdownH2", { link = "@markup.heading.2.markdown" })
  hl(0, "RenderMarkdownH3", { link = "@markup.heading.3.markdown" })
  hl(0, "RenderMarkdownH4", { link = "@markup.heading.4.markdown" })
  hl(0, "RenderMarkdownH5", { link = "@markup.heading.5.markdown" })
  hl(0, "RenderMarkdownH6", { link = "@markup.heading.6.markdown" })

  -- Heading backgrounds
  hl(0, "RenderMarkdownH1Bg", { bg = "#252a30" })
  hl(0, "RenderMarkdownH2Bg", { bg = "#232a2b" })
  hl(0, "RenderMarkdownH3Bg", { bg = "#28252b" })
  hl(0, "RenderMarkdownH4Bg", { bg = "#272a26" })
  hl(0, "RenderMarkdownH5Bg", { bg = "#2d2825" })
  hl(0, "RenderMarkdownH6Bg", { bg = "#29272a" })

  -- Standard markdown code block highlights (BRIGHT for dataview visibility)
  hl(0, "markdownCodeBlock", { fg = colors.text, bg = "NONE" })
  hl(0, "markdownCodeDelimiter", { fg = colors.blue })
  hl(0, "markdownCode", { fg = colors.green })  -- Inline code

  -- RenderMarkdown code block highlights (brighter text for better visibility)
  hl(0, "RenderMarkdownCode", { fg = colors.text, bg = colors.surface0 })
  hl(0, "RenderMarkdownCodeInfo", { fg = colors.overlay2, bg = colors.surface0 })
  hl(0, "RenderMarkdownCodeBorder", { fg = colors.surface1, bg = colors.surface0 })
  hl(0, "RenderMarkdownCodeFallback", { fg = colors.orange, bg = colors.surface0 })
  hl(0, "RenderMarkdownCodeInline", { fg = colors.green, bg = colors.surface0 })

  -- Quote highlights (nested quotes with progressive colors)
  hl(0, "RenderMarkdownQuote", { fg = colors.subtext1 })
  hl(0, "RenderMarkdownQuote1", { fg = colors.yellow })
  hl(0, "RenderMarkdownQuote2", { fg = colors.orange })
  hl(0, "RenderMarkdownQuote3", { fg = colors.red })
  hl(0, "RenderMarkdownQuote4", { fg = colors.violet })
  hl(0, "RenderMarkdownQuote5", { fg = colors.blue })
  hl(0, "RenderMarkdownQuote6", { fg = colors.cyan })

  -- List bullets
  hl(0, "RenderMarkdownBullet", { fg = colors.cyan })

  -- Checkboxes
  hl(0, "RenderMarkdownUnchecked", { fg = colors.overlay1 })
  hl(0, "RenderMarkdownChecked", { fg = colors.green })
  hl(0, "RenderMarkdownTodo", { fg = colors.yellow })

  -- Horizontal rule/dash
  hl(0, "RenderMarkdownDash", { fg = colors.surface2 })

  -- Sign column
  hl(0, "RenderMarkdownSign", { bg = opts.transparent_background and "NONE" or colors.base })

  -- Math/LaTeX
  hl(0, "RenderMarkdownMath", { fg = colors.violet })

  -- Indent guides
  hl(0, "RenderMarkdownIndent", { fg = colors.surface1 })

  -- Links
  hl(0, "RenderMarkdownLink", { fg = colors.blue, underline = true })

  -- Tables
  hl(0, "RenderMarkdownTableHead", { fg = colors.yellow, bold = true })
  hl(0, "RenderMarkdownTableRow", { fg = colors.text })
  hl(0, "RenderMarkdownTableFill", { fg = colors.surface1 })

  -- Callouts
  hl(0, "RenderMarkdownSuccess", { fg = colors.green })
  hl(0, "RenderMarkdownInfo", { fg = colors.blue })
  hl(0, "RenderMarkdownHint", { fg = colors.cyan })
  hl(0, "RenderMarkdownWarn", { fg = colors.yellow })
  hl(0, "RenderMarkdownError", { fg = colors.red })
end

return M
