return {
  {
    "mbbill/undotree",
    -- Install undotree using Lazy
    -- Optional: Configure undotree
    config = function()
      -- Set up persistent undo
      if vim.fn.has("persistent_undo") == 1 then
        local target_path = vim.fn.expand("~/.undodir")
        if not vim.fn.isdirectory(target_path) then
          vim.fn.mkdir(target_path, "p", 0700)
        end
        vim.opt.undodir = target_path
        vim.opt.undofile = true
      end

      local wk = require("which-key")
      wk.add({
        {
          "<leader>u",
          function()
            vim.cmd.UndotreeToggle()
            vim.cmd.UndotreeFocus()
          end,
          desc = "Open undo tree",
          icon = { icon = "󰕌" },
        },
      })
    end,
  },
}

