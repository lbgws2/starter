return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- event = "VeryLazy",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you prefer nvim-web-devicons
  opts = function()

--vim.api.nvim_set_hl(0, '@markup.quote',  { fg = "#efef33", bg = "#3d59a1" })
    vim.api.nvim_set_hl(0, "@markup.italic", { italic = true, fg = "#FF9966", bg = "#313244" })
    vim.api.nvim_set_hl(0, "@markup.link.label", {  fg = "#218bff", bg = "#313244" })
    vim.api.nvim_set_hl(0, "@markup.strong", { bold = true, fg = "#EE2C2C", bg = "#313244", undercurl = false })

vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = false ,underline = false })
  end,
}
