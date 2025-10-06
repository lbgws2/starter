vim.opt.autoread = true -- Update buffer if file has changed outside vim.
-----关闭临时文件

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autochdir = true

vim.opt.encoding = "utf-8"
--vim.opt.wrap = false
--vim.opt.linebreak = true
--vim.opt.textwidth = 80
--vim.opt.breakindent = false
-- vim.opt.formatoptions:remove('t') -- No autoformatting
-- vim.opt.formatoptions:append('m') -- Respect textwidth
-- vim.opt.formatoptions:append('r') -- Do continue on enter
-- vim.opt.showbreak = "↳ "
