-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local M = {}


-- local function 按键()

-- keymap.del("i", "<Home>", {})


------可替换按键
--ctrl+y
--ctrl+e
--ctrl+d
--ctrl+f


--编辑设置
vim.keymap.set("n", "<leader>fr", "<cmd>set wrap!<CR>", { desc = "return line 换行" })
keymap.set({ "i", "n", "v" }, "<C-z>", "<cmd>undo<CR>", { silent = true, noremap = true }) --撤销
--keymap.set({ "i", "n","v" }, "<C-y>", "<cmd>redo<CR>", { silent = true, noremap = true }) --重做
vim.cmd [[
let g:ZFVimIM_keymap = 0

" nnoremap <expr><silent> ;; ZFVimIME_keymap_toggle_n()
inoremap <expr><silent> jj ZFVimIME_keymap_toggle_i()
" vnoremap <expr><silent> ;; ZFVimIME_keymap_toggle_v()

" nnoremap <expr><silent> ;: ZFVimIME_keymap_next_n()
inoremap <expr><silent> ;: ZFVimIME_keymap_next_i()
" vnoremap <expr><silent> ;: ZFVimIME_keymap_next_v()

" nnoremap <expr><silent> ;, ZFVimIME_keymap_add_n()
inoremap <expr><silent> ;, ZFVimIME_keymap_add_i()
" xnoremap <expr><silent> ;, ZFVimIME_keymap_add_v()

" nnoremap <expr><silent> ;. ZFVimIME_keymap_remove_n()
inoremap <expr><silent> ;. ZFVimIME_keymap_remove_i()
" xnoremap <expr><silent> ;. ZFVimIME_keymap_remove_v()
]]

keymap.set({ "i", "n" }, "<C-k>", "<cmd>move -2<CR>")                                  --向上移动行
keymap.set({ "i", "n" }, "<C-j>", "<cmd>move +1<CR>")                                  --向下移动行

keymap.set({ "i", "n", "v" }, "<C-a>", "<Esc>ggVG", { silent = true, noremap = true }) --全选


vim.keymap.set("n", "<S-LEFT>", "v<LEFT>", { desc = "Select left" })

vim.keymap.set("v", "<S-LEFT>", "<LEFT>", { desc = "Select left" })
vim.keymap.set("i", "<S-LEFT>", "<LEFT><C-o>v", { desc = "Select left" })

vim.keymap.set("n", "<S-RIGHT>", "v<RIGHT>", { desc = "Select right" })
vim.keymap.set("v", "<S-RIGHT>", "<RIGHT>", { desc = "Select right" })
vim.keymap.set("i", "<S-RIGHT>", "<C-o>v", { desc = "Select right" })

vim.keymap.set("n", "<S-UP>", "v<UP>", { desc = "Select up" })
vim.keymap.set("v", "<S-UP>", "<UP>", { desc = "Select up" })
vim.keymap.set("i", "<S-UP>", "<LEFT><C-o>v<UP><RIGHT>", { desc = "Select up" })

vim.keymap.set("n", "<S-DOWN>", "v<DOWN>", { desc = "Select down" })
vim.keymap.set("v", "<S-DOWN>", "<DOWN>", { desc = "Select down" })
vim.keymap.set("i", "<S-DOWN>", "<C-o>v<DOWN><LEFT>", { desc = "Select down" })

vim.keymap.set("n", "<S-HOME>", "v^", { desc = "Select to first character" })
vim.keymap.set("v", "<S-HOME>", "^", { desc = "Select to first character" })
vim.keymap.set("i", "<S-HOME>", "<LEFT><C-o>v^", { desc = "Select to first character" })

vim.keymap.set("n", "<S-END>", "vg_", { desc = "Select to last character" })
vim.keymap.set("v", "<S-END>", "g_", { desc = "Select to last character" })
vim.keymap.set("i", "<S-END>", "<C-o>vg_", { desc = "Select to last character" })


--重要设置
keymap.set("n", "<Leader>wn", "<c-w>p") --切换窗口

---跳转设定
vim.keymap.set("n", "gj", "``", { desc = "上次跳转位置,待理解" })
--gi           上次插入模式光标位置
--g,	 跳到下一个编辑位置
--g;	 跳到上一个编辑位置




-- keymap.set("i", "z", "<c-l>")
-- keymap.set("i", "<c-.>", "<c-e>")
keymap.set("n", "<Leader>fl", ":source %<CR>")                                     --快速重载配置文件
-- keymap.set("i", "<Home>", "<Home>" )
keymap.set("n", "<Leader>ck", ":e $HOME/.config/nvim/lua/config/keymaps.lua<CR>")  --快速编辑keymap
keymap.set("n", "<Leader>ca", ":e $HOME/.config/nvim/lua/config/autocmds.lua<CR>") --快速编辑autocmds
keymap.set("n", "<Leader>cp", ":e $HOME/.config/nvim/lua/plugins/example.lua<CR>") --快速编辑插件设置
keymap.set("n", "<Leader>fg", "<cmd>Telescope live_grep<cr>")                      --快速编辑插件设置
-- keymap.set({ "i", "n" }, "<C-u>", "<cmd>!python %<CR>", { silent = true, noremap = true }) --快速编辑插件设置
-- keymap.set("n", "<C-u>", "<cmd>!python %<CR>", { silent = true, noremap = true })  --快速编辑插件设置
--verbose map    --查看所有已定义的快捷键
--user_function
-- keymap.set("i", "<C-u>", "<c-o>gcc")                                               --注释切换



-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
function _G.markdown_foldexpr()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)
  local heading = line:match("^(#+)%s")
  if heading then
    local level = #heading
    if level == 1 then
      -- Special handling for H1
      if lnum == 1 then
        return ">1"
      else
        local frontmatter_end = vim.b.frontmatter_end
        if frontmatter_end and (lnum == frontmatter_end + 1) then
          return ">1"
        end
      end
    elseif level >= 2 and level <= 6 then
      -- Regular handling for H2-H6
      return ">" .. level
    end
  end
  return "="
end

local function set_markdown_folding()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
  vim.opt_local.foldlevel = 99

  -- Detect frontmatter closing line
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local found_first = false
  local frontmatter_end = nil
  for i, line in ipairs(lines) do
    if line == "---" then
      if not found_first then
        found_first = true
      else
        frontmatter_end = i
        break
      end
    end
  end
  vim.b.frontmatter_end = frontmatter_end
end

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = set_markdown_folding,
})

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Check if the current line has a fold level > 0
      local current_foldlevel = vim.fn.foldlevel(line)
      if current_foldlevel > 0 then
        -- Fold the heading if it matches the level
        if vim.fn.foldclosed(line) == -1 then
          vim.cmd("normal! za")
        end
        -- else
        --   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
      end
    end
  end
end

local function fold_markdown_headings(levels)
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "zj", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otheriise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 1 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "zk", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "zl", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 3 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "z;", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
    vim.cmd("normal! zz") -- center the cursor line on screen
  end
end, { desc = "[P]Toggle fold" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "zu", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Unfold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "zi", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- Difference between normal and normal!
  -- - `normal` executes the command and respects any mappings that might be defined.
  -- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
  vim.cmd("normal gk")
  -- This is to fold the line under the cursor
  vim.cmd("normal! za")
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold the heading cursor currently on" })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------
