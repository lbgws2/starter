return {
  "glacambre/firenvim",

  -- Lazy load firenvim
  -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  lazy = not vim.g.started_by_firenvim,
  module = false,
  build = function() vim.fn["firenvim#install"](0) end,

  init = function()
    vim.opt.wrap = true
    vim.g.firenvim_config = {
      globalSettings = { alt = "all" },
      autocmds = {
        { "BufEnter", "platejs.org_*.txt", "setlocal filetype=markdown" },
        { "BufEnter", "leetcode.com_*.js", "setlocal filetype=typescript" },
        {
          "BufEnter",
          "gitter.im_*.txt",
          [[setlocal filetype=markdown | nnoremap <leader><CR> write<CR>:call firenvim#press_keys("<Lt>CR>")<CR>ggdGa]],
        },
      },
      localSettings = {
        [".*"] = {
          filename = "/tmp/{hostname%32}_{pathname%10}.md",
          priority = 1,
          takeover = 'never'
        },
        ['https://github\\.com/.+/.+/(issues|pull|discussions|compare|wiki).*'] = {
          cmdline  = 'neovim',
          content  = 'text',
          priority = 1,
          selector = 'textarea',
          takeover = 'always',
          filename = '{hostname%32}_{pathname%32}_{selector%32}_{timestamp%32}.md',
        },
        ['https://gitee\\.com/lbgws2/.+/edit/.*'] = {
          cmdline  = 'neovim',
          content  = 'text',
          priority = 1,
          selector = 'textarea',
          takeover = 'once',
          filename = '{hostname%32}_{pathname%32}_{selector%32}_{timestamp%32}.md',
        },
        ['https://www.jianguoyun.com/'] = {
          content  = 'txt',
          priority = 1,
          selector = 'pre[class="markdown-highlighting editor__inner"]',
          -- selector = 'div[class="cledit-section"]',
          takeover = 'always',
        },
        ['https://vika.cn/'] = {
          content  = 'md',
          priority = 1,
          selector = 'div[class="tiptap ProseMirror"]',
          takeover = 'always',
        },
        ['https://www.evernote.com/'] = {
          selector = "en-note",
          takeover = "always"
        },
        ['www.notion.so.*'] = {
          takeover = 'always',
          priority = 1
        },
        ['https://app.yinxiang.com/*'] = {
          selector = "en-note",
          takeover = "always"
        },
      },
    }
  end,
}

