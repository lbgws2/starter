-- reference: https://www.bugsnag.com/blog/tmux-and-vim/
return {
  'preservim/vimux',
  event = 'VeryLazy',
  config = function()
    vim.cmd("let g:VimuxOrientation = 'h'")
    vim.cmd("let g:VimuxHeight = '80'")
    vim.keymap.set('n', '<leader>vp', ':VimuxPromptCommand<CR>', { desc = 'Prompt for a command to run' })
    vim.keymap.set('n', '<leader>vl', ':VimuxRunLastCommand<CR>',
      { desc = 'Run last command executed by VimuxRunCommand' })
    vim.keymap.set('n', '<Leader>vi', ':VimuxInspectRunner<CR>')     -- Inspect runner pane
    vim.keymap.set('n', '<Leader>vq', ':VimuxCloseRunner<CR>')       -- Close vim tmux runner opened by VimuxRunCommand
    vim.keymap.set('n', '<Leader>vx', ':VimuxInterruptRunner<CR>')   -- Interrupt any command running in the runner pane
    vim.keymap.set('n', '<Leader>vz', ':call VimuxZoomRunner()<CR>') -- Zoom the runner pane (use <bind-key> z to restore runner pane)

    vim.keymap.set('n', '<leader>vc', function()
      vim.cmd('call VimuxRunCommand("curl -s https://jsonplaceholder.typicode.com/posts | jq \'.[] | .body\'")')
    end, { buffer = true, desc = 'restful' })
    vim.keymap.set("n", "<leader>tl", function()
      local line = vim.fn.getline(".")
      vim.cmd("VimuxRunCommand '" .. line .. "'")
    end)
    -- vim.keymap.set('n', '<leader>vi', ':VimuxInspectRunner<CR>', { desc = 'Inspect runner pane' })
    -- vim.keymap.set('n', '<leader>vz', ':VimuxZoomRunner<CR>', { desc = 'Zoom the tmux runner pane' })
    --curl -G 'http://192.168.1.97:4001/db/query?pretty&timings' --data-urlencode 'q=SELECT * FROM note' | jq '.' | nvim -
  end,
}
