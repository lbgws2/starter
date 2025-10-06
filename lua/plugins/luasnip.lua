return {
  'L3MON4D3/LuaSnip',
  config = function(opts)
    local ls = require('luasnip')
    require('luasnip.loaders.from_lua').lazy_load({
      paths = { vim.fn.stdpath('config') .. '/lua/snippets' },
    })

    ls.config.set_config(opts)
    vim.cmd [[
    " Expand or jump in insert mode
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
    " Jump forward through tabstops in visual mode
    smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

    " Jump backward through snippet tabstops with Shift-Tab (for example)
    imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
    smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
    inoremap <c-u> <cmd>lua require("luasnip.extras.select_choice")()<cr>
    " Cycle forward through choice nodes with Control-f (for example)
    " imap <silent><expr> <C-u> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
    " smap <silent><expr> <C-u> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
    ]]
  end,
  -- keys = {
  --   { "<C-u>", "<cmd>luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'", mode = "i" },
  --   { "<C-u>", "<cmd>luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'", mode = "s" },
  --   {
  --     '<A-k>',
  --     '<cmd>lua require("luasnip").jump(-1)<CR>',
  --     mode = { 'i', 's' },
  --     desc = 'Jump to previous snippet',
  --   },
  --   {
  --     '<C-j>',
  --     '<cmd>lua require("luasnip").jump(1)<CR>',
  --     mode = { 'i', 's' },
  --     desc = 'Jump to next snippet',
  --   },
  --   {
  --     "<c-l>", -- complete without blink.nvim
  --     function()
  --       if require("luasnip").expand_or_jumpable() then
  --         require("luasnip").expand_or_jump()
  --       end
  --     end,
  --     desc = "Expand snippet or jump forward",
  --     mode = { "i", "s" },
  --   },
  --   -- {
  --   --   '<C-l>',
  --   --   '<cmd>lua if ls.choice_active() then ls.change_choice(1) end<CR>',
  --   --   mode = { 'i', 's' },
  --   --   desc = 'Change snippet choice',
  --   -- },
  --   {
  --     '<C-h>',
  --     '<cmd>lua if ls.choice_active() then ls.change_choice(-1) end<CR>',
  --     mode = { 'i', 's' },
  --     desc = 'Change snippet choice',
  --   },
  --   {
  --     '<C-u>',
  --     '<cmd>lua require("luasnip.extras.select_choice")()<CR>',
  --     mode = { 'i', 's' },
  --     desc = 'Select snippet choice',
  --   },
  -- },
}
