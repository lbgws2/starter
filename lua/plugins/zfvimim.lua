return {
  -- 输入法插件本体
  { "ZSaberLv0/ZFVimIM",           event = "VeryLazy" },
  { "ZSaberLv0/ZFVimJob",          event = "VeryLazy" }, -- 提高词库加载性能
  -- "ZSaberLv0/ZFVimIM_pinyin_base", -- 单个单词基本拼音库 -- 轻量需要diy
  { "ZSaberLv0/ZFVimIM_wubi_base", event = "VeryLazy" }, -- 作者拼音数据库
  -- { "ZSaberLv0/ZFVimIM_english_base", event = "VeryLazy" }, -- 英文单词库
  -- "ZSaberLv0/ZFVimIM_pinyin_huge", -- 其他输入法转换的巨大数据库
  -- 使用说明
  -- ;; 打开或关闭输入法, ;:切换词库
  -- - 和 = 翻页
  -- 空格 和 0~9 选词或组词
  -- [ 和 ] 快速从词组选字
  config = function()
    local G = require("G")
    G.cmd([[
    set encoding = utf-8
    set fileencoding = utf-8
    set fileencodings = utf-8, ucs-bom, chinese
    ]])
  end
}
