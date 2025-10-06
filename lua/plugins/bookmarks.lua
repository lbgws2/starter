return {
  --另一个可能的项目https://github.com/chentoast/marks.nvim

  {
    "MattesGroeger/vim-bookmarks",

    init = function()
      vim.g.bookmark_no_default_key_mappings = 1
      vim.g.bookmark_save_per_working_dir = 1
      vim.g.bookmark_sign = ""
    end,
    config = function()
      vim.keymap.set('n', 'mm', '<Plug>BookmarkToggle', { desc = "Bookmark toggle" })
      vim.keymap.set('n', 'ma', '<Plug>BookmarkAnnotate', { desc = "Bookmark annotate" })
      vim.keymap.set('n', 'mc', '<cmd>Telescope vim_bookmarks current_file<cr>', { desc = "Bookmark current list" })
      vim.keymap.set('n', 'ml', '<cmd>Telescope vim_bookmarks all<cr>', { desc = "Bookmark all list" })
      vim.keymap.set('n', 'mn', '<Plug>BookmarkNext', { desc = "Bookmark next" })
      vim.keymap.set('n', 'mp', '<Plug>BookmarkPrev', { desc = "Bookmark previous" })
    end,
    cond = not_vscode
  },
  {
    "tom-anders/telescope-vim-bookmarks.nvim",

    event = 'VeryLazy',

    cond = not_vscode
  },
}
