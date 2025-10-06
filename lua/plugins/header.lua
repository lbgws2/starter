-- markdown-headings-single.lua
-- LazyVim单文件Markdown标题提取插件
-- 使用Tree-sitter解析ATX格式标题，智能构建标题层次结构
-- 作者: Assistant
-- 版本: 1.0.0
-- 使用方法: 将此文件放置在 ~/.config/nvim/lua/plugins/ 目录下

local M = {}

-- 检查Tree-sitter是否可用
local function has_treesitter()
  local ok, _ = pcall(require, "nvim-treesitter")
  return ok
end

-- 检查当前buffer是否为markdown文件
local function is_markdown_buffer()
  local filetype = vim.bo.filetype
  return filetype == "markdown" or filetype == "md"
end

-- 获取当前buffer的Tree-sitter解析器
local function get_parser()
  if not has_treesitter() then
    vim.notify("Tree-sitter不可用，请确保已安装nvim-treesitter插件", vim.log.levels.ERROR)
    return nil
  end

  local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
  if not ok then
    vim.notify("无法获取markdown解析器，请运行:TSInstall markdown", vim.log.levels.ERROR)
    return nil
  end

  return parser
end

-- 从ATX标题文本中提取标题级别
local function get_heading_level(text)
  local level = 0
  for i = 1, #text do
    if text:sub(i, i) == "#" then
      level = level + 1
    else
      break
    end
  end
  return level
end

-- 提取标题文本，移除#符号和多余空格
local function get_heading_text(text)
  local clean_text = text:gsub("^#+%s*", "")
  clean_text = clean_text:gsub("%s*#+%s*$", "") -- 移除尾部的#
  return vim.trim(clean_text)
end

-- 使用Tree-sitter查询ATX标题
local function query_headings(parser)
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Tree-sitter查询语句，匹配ATX标题
  local query_string = [[
    (atx_heading) @heading
  ]]

  local ok, query = pcall(vim.treesitter.query.parse, "markdown", query_string)
  if not ok then
    vim.notify("Tree-sitter查询解析失败", vim.log.levels.ERROR)
    return {}
  end

  local headings = {}

  for id, node in query:iter_captures(root, 0) do
    local start_row, start_col, end_row, end_col = node:range()
    local text = vim.treesitter.get_node_text(node, 0)

    local level = get_heading_level(text)
    local heading_text = get_heading_text(text)

    table.insert(headings, {
      level = level,
      text = heading_text,
      line = start_row + 1, -- 转换为1基行号
      col = start_col + 1,  -- 转换为1基列号
      end_line = end_row + 1,
      end_col = end_col + 1,
      raw_text = text
    })
  end

  -- 按行号排序
  table.sort(headings, function(a, b)
    return a.line < b.line
  end)

  return headings
end

-- 根据光标位置构建标题层次结构
local function build_heading_hierarchy(headings, cursor_line)
  local hierarchy = {}
  local current_levels = {}

  -- 找到光标位置对应的标题层次
  for _, heading in ipairs(headings) do
    if heading.line <= cursor_line then
      -- 更新当前级别，清除更深层级
      for i = heading.level, 6 do
        current_levels[i] = nil
      end
      current_levels[heading.level] = heading
    else
      break
    end
  end

  -- 从1级到最深级别构建层次结构
  for level = 1, 6 do
    if current_levels[level] then
      table.insert(hierarchy, current_levels[level])
    end
  end

  return hierarchy
end



-- 在新buffer中显示当前位置的上级标题层次
local function display_current_hierarchy(hierarchy, cursor_line)
  -- 创建新buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown-headings")

  local lines = {}
  local current_heading_line = nil

  -- -- 添加标题
  -- table.insert(lines, "# 当前位置的标题层次")
  -- table.insert(lines, "")

  -- -- 显示当前层次结构
  -- if #hierarchy > 0 then
  --   table.insert(lines, "## 光标位于第" .. cursor_line .. "行的上级标题")
  --   table.insert(lines, "")

  for i, heading in ipairs(hierarchy) do
    table.insert(lines, heading.text)
    if i == #hierarchy then
      current_heading_line = #lines
    end
  end

  -- table.insert(lines, "")
  -- table.insert(lines, "## 标题路径")
  -- table.insert(lines, "")

  -- 显示面包屑导航样式的路径
  -- local breadcrumb = {}
  -- for _, heading in ipairs(hierarchy) do
  --   table.insert(breadcrumb, heading.text)
  -- end
  -- table.insert(lines, "📍 " .. table.concat(breadcrumb, " > "))
  -- else
  --   table.insert(lines, "## 当前位置")
  --   table.insert(lines, "")
  --   table.insert(lines, "光标位于第" .. cursor_line .. "行，未找到上级标题")
  --   table.insert(lines, "")
  --   table.insert(lines, "💡 提示：光标可能位于文档开头或所有标题之前")
  -- end

  -- 添加使用说明
  -- table.insert(lines, "")
  -- table.insert(lines, "## 操作说明")
  -- table.insert(lines, "")
  -- table.insert(lines, "- 按 Enter 跳转到选中的标题")
  -- table.insert(lines, "- 按 q 或 Esc 关闭此窗口")
  -- table.insert(lines, "- ► 标记表示当前光标所在的最深层级标题")
  -- table.insert(lines, "- 📍 显示完整的标题路径")

  -- 设置buffer内容
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- 在新窗口中打开
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
  -- vim.api.nvim_buf_set_name(buf, "[当前标题层次]")

  -- 设置光标位置到当前标题
  if current_heading_line then
    vim.api.nvim_win_set_cursor(0, { current_heading_line, 0 })
  end

  -- 设置buffer快捷键
  local opts = { buffer = buf, silent = true }
  vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", opts)
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local line_num = line:match("第(%d+)行")
    if line_num then
      vim.cmd("close")
      vim.api.nvim_win_set_cursor(0, { tonumber(line_num), 0 })
    end
  end, opts)
end

-- 主要功能：提取当前位置的上级标题
function M.extract_headings()
  -- 检查是否为markdown文件
  if not is_markdown_buffer() then
    vim.notify("当前文件不是Markdown格式", vim.log.levels.WARN)
    return
  end

  -- 获取Tree-sitter解析器
  local parser = get_parser()
  if not parser then
    return
  end

  -- 获取当前光标位置
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor_pos[1]

  -- 使用Tree-sitter查询标题
  local headings = query_headings(parser)

  if #headings == 0 then
    vim.notify("未找到任何ATX格式标题", vim.log.levels.INFO)
    return
  end

  -- 构建当前位置的标题层次结构
  local hierarchy = build_heading_hierarchy(headings, cursor_line)

  -- 显示当前位置的上级标题层次
  display_current_hierarchy(hierarchy, cursor_line)
end

-- LazyVim插件配置
return {
  -- 插件名称（使用dir指向本文件）
  {
    "markdown-headings-single",
    dir = vim.fn.expand("%:p:h"),        -- 当前文件所在目录
    ft = { "markdown", "md" },           -- 仅在markdown文件中加载
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- 依赖Tree-sitter
    },

    -- 插件配置函数
    config = function()
      -- 创建用户命令
      vim.api.nvim_create_user_command("ExtractHeadings", function()
        M.extract_headings()
      end, {
        desc = "显示当前位置的上级标题层次"
      })

      -- 设置全局快捷键
      vim.keymap.set("n", "<Leader>mh", function()
        M.extract_headings()
      end, {
        desc = "显示当前位置的上级标题",
        silent = true
      })

      -- 为markdown文件设置buffer-local快捷键
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "md" },
        callback = function()
          vim.keymap.set("n", "<Leader>mh", function()
            M.extract_headings()
          end, {
            desc = "显示当前位置的上级标题",
            silent = true,
            buffer = true
          })

          -- 添加额外的快捷键
          vim.keymap.set("n", "<Leader>mt", function()
            M.extract_headings()
          end, {
            desc = "显示当前标题层次",
            silent = true,
            buffer = true
          })
        end,
      })

      -- 显示加载成功消息
      -- vim.notify("Markdown标题层次插件已加载 - 使用<Leader>mh显示当前位置的上级标题", vim.log.levels.INFO)
    end,

    -- 插件元数据
    name = "markdown-headings-single",
    version = "1.0.0",
  },
}
