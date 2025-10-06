-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Jump to the last known cursor position if it's valid (from the docs).

local M = {}
local function get_url_title(url)
  -- 异步获取标题
  local job = vim.fn.jobstart({ 'curl', '-s', '-L', url }, {
    on_stdout = function(_, data, __)
      local html = table.concat(data, '')
      local title = html:match('<title>(.-)</title>')
      if title then
        title = title:gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
        -- 替换当前行中的 URL 为 Markdown 链接
        local line = vim.fn.getline('.')
        local new_line = line:gsub(url, '[' .. title .. '](' .. url .. ')')
        vim.fn.setline('.', new_line)
      else
        print('Title not found for URL: ' .. url)
      end
    end,
    on_stderr = function(_, data, __)
      print('Error fetching URL: ' .. table.concat(data, ''))
    end
  })
  if job <= 0 then
    print('Failed to start job for URL: ' .. url)
  end
end


vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = function()
    local line = vim.fn.getline('.')
    local url = line:match('https?://%S+')
    if url then
      get_url_title(url)
    end
  end
})

-- 映射快捷键（Normal 模式）
vim.api.nvim_set_keymap('n', '<leader>gt', [[:lua require('your_config').get_url_title_from_cursor()<CR>]],
  { noremap = true, silent = true })

-- 提取光标下的 URL 并调用函数
function _G.get_url_title_from_cursor()
  local url = vim.fn.expand('<cWORD>') -- 获取光标下的单词（假设是 URL）
  get_url_title(url)
end

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore the cursor position when reopening the buffer.",
  group = vim.api.nvim_create_augroup("last-position-jump", { clear = true }),
  callback = function()
    local row
    if vim.bo.filetype == "gitcommit" then
      row = 1
    else
      row, _ = unpack(vim.api.nvim_buf_get_mark(0, '"'))
      if row == nil then
        row = 1
      else
        -- If the file has never lines than the previous position, go to the end.
        local last_line = vim.api.nvim_buf_line_count(0)
        if row > last_line then
          row = last_line
        end
      end
    end

    if row > 0 then
      vim.api.nvim_win_set_cursor(0, { row, 0 })
    end
  end,
})

-- local cmd = vim.cmd
local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local create_command = vim.api.nvim_create_user_command
create_command("Syncs", ":PackerSync", { desc = "PackerSync" })

-- set ALL_PROXY=http://127.0.0.1:7890
--使用augroup避免autocmd反复加载


cmd("BufEnter", {
  desc = "Disable autocommenting in new lines",
  command = "set fp-=c fo-=r fo-=o",
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    -- ImeOne()
    -- vim.fn.execute("silent! write")
  end,
  -- command ="lua ImeOne()"
})

--  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
--       callback = function()
--           -- vim.fn.system('curl https://push.getquicker.cn/to/quicker\\?toUser\\=31537805@qq.com\\&code\\=pFvkeHFbDk\\&operation\\=action\\&action\\=53f707aa-e58a-443b-9bcd-9c7f697fe628')
--
--       end,
--  })

function ImeOne()
  vim.fn.system(
    'curl https://push.getquicker.cn/to/quicker\\?toUser\\=31537805@qq.com\\&code\\=pFvkeHFbDk\\&operation\\=action\\&action\\=53f707aa-e58a-443b-9bcd-9c7f697fe628')
end

--
-- vim.api.nvim_create_user_command(
--     'Split_note',
--     function()
--       local result = vim.api.nvim_exec(
--         [[
-- --             let data ="333"
-- --             vsplit tem_note
-- --             call setbufline('tem_note', 1, split(data, "\n"))
--         ]],
-- true)
--   print(result)
--   end, {}
-- )
--

vim.api.nvim_create_user_command(
  'Toeng',
  function()
    local result = vim.api.nvim_exec(
      [[
          let url = 'https://push.getquicker.cn/to/quicker?toUser=31537805@qq.com&code=pFvkeHFbDk&operation=action&action=53f707aa-e58a-443b-9bcd-9c7f697fe628'
          let mytext = 'hello world'

          function! MyFunction(text)
            ## echo a:text
            system("curl https://push.getquicker.cn/to/quicker?toUser=31537805@qq.com&code=pFvkeHFbDk&operation=action&action=53f707aa-e58a-443b-9bcd-9c7f697fe628")
          endfunction

          call MyFunction(url)

        ]],
      true)
    print(result)
  end, {}
)

vim.api.nvim_create_user_command(
  'ImeSwitch',
  function()
    print(vim.fn.system(
      'curl https://push.getquicker.cn/to/quicker\\?toUser\\=31537805@qq.com\\&code\\=pFvkeHFbDk\\&operation\\=action\\&action\\=53f707aa-e58a-443b-9bcd-9c7f697fe628'))
  end,
  {}

)


function M.url_encode(str)
  if str then
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
      return string.format("%%%02X", string.byte(c))
    end)
    str = string.gsub(str, " ", "+")
  end
  return str
end

-- web版vscode设置,复制后传送到本机quicker
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    -- local text = vim.fn.getreg('*')
    local text = vim.fn.getreg('"')
    -- 需要对文字进行编码
    local encoded = M.url_encode(text)
    vim.fn.system(
      'curl https://push.getquicker.cn/to/quicker\\?toUser\\=31537805@qq.com\\&code\\=pFvkeHFbDk\\&operation=copy\\&data=' ..
      encoded)
  end,
})


-- vim.api.nvim_create_user_command(
--   'Markfile',
--   function()
--     local file = io.open("~/mark.txt", "r")
--
--     io.input(file)
--
--     -- 输出文件第一行
--   end,
--   {}
--
--)
