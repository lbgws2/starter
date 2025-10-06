return {
  -- https://github.com/img-paste-devs/img-paste.vim
  -- https://github.com/hakonharnes/img-clip.nvim
  -- 从剪贴板插入图片
  --   "ferrine/md-img-paste.vim",
  --   event = 'VeryLazy',
  --   -- ft = "markdown",
  --   config = function()
  --   end


  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    -- add options here
    -- or leave it empty to use the default settings
  },
  keys = {
    -- suggested keymap
    { "<leader>fp", "<cmd>PasteImage<cr>", desc = "Paste image file from system clipboard" },
  },
  vim.keymap.set({ "n", "i" }, "<M-a>", function()
    local pasted_image = require("img-clip").paste_image()
    if pasted_image then
      -- "Update" saves only if the buffer has been modified since the last save
      vim.cmd("silent! update")
      -- Get the current line
      local line = vim.api.nvim_get_current_line()
      -- Move cursor to end of line
      vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
      -- I reload the file, otherwise I cannot view the image after pasted
      vim.cmd("edit!")
    end
  end, { desc = "[P]Paste image from system clipboard" })
}
