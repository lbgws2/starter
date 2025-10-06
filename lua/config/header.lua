-- markdown_headers.lua
-- 使用Tree-sitter解析Markdown结构，向上查找当前行所属的标题，并将各级标题提取到新buffer

local M = {}

-- 确保已安装markdown解析器
local function ensure_parser()
  local parser_installed = vim.treesitter.language.require_language("markdown", nil, true)
  if not parser_installed then
    vim.notify("需要安装markdown的tree-sitter解析器", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- 获取当前buffer的解析树
local function get_parser()
  local buf = vim.api.nvim_get_current_buf()
  return vim.treesitter.get_parser(buf, "markdown")
end

-- 创建用于查找标题的查询
local function create_heading_query()
  -- 查询所有标题节点
  local query_str = [[
    (atx_heading) @heading
    (setext_heading) @heading
  ]]
  return vim.treesitter.query.parse("markdown", query_str)
end

-- 获取节点的文本内容
local function get_node_text(node)
  local buf = vim.api.nvim_get_current_buf()
  local start_row, start_col, end_row, end_col = node:range()
  if start_row == end_row then
    local line = vim.api.nvim_buf_get_lines(buf, start_row, start_row + 1, false)[1]
    return line:sub(start_col + 1, end_col)
  else
    local lines = vim.api.nvim_buf_get_lines(buf, start_row, end_row + 1, false)
    lines[1] = lines[1]:sub(start_col + 1)
    lines[#lines] = lines[#lines]:sub(1, end_col)
    return table.concat(lines, "\n")
  end
end

-- 获取标题级别
local function get_heading_level(node)
  local node_type = node:type()
  if node_type == "atx_heading" then
    -- 对于ATX标题 (# 标题)，查找子节点中的 "atx_h1_marker" 到 "atx_h6_marker"
    for child in node:iter_children() do
      local child_type = child:type()
      if child_type:match("atx_h(%d)_marker") then
        return tonumber(child_type:match("atx_h(%d)_marker"))
      end
    end
  elseif node_type == "setext_heading" then
    -- 对于Setext标题 (标题\n----)，查找子节点中的 "setext_h1_underline" 或 "setext_h2_underline"
    for child in node:iter_children() do
      local child_type = child:type()
      if child_type == "setext_h1_underline" then
        return 1
      elseif child_type == "setext_h2_underline" then
        return 2
      end
    end
  end
  return nil
end

-- 获取标题文本（去除#符号）
local function get_heading_text(node)
  local text = get_node_text(node)
  local level = get_heading_level(node)

  if node:type() == "atx_heading" then
    -- 移除开头的#号和空格
    text = text:gsub("^#+%s*", "")
    -- 移除可能存在的尾部#号
    text = text:gsub("%s*#+%s*$", "")
  end

  return text:gsub("^%s*(.-)%s*$", "%1") -- 去除首尾空白
end

-- 查找当前行所属的所有标题（包括上级标题）
function M.find_current_headings()
  if not ensure_parser() then return {} end

  local parser = get_parser()
  local query = create_heading_query()
  local tree = parser:parse()[1]
  local root = tree:root()

  local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
  local headings = {}

  -- 收集所有标题节点
  for id, node in query:iter_captures(root, 0) do
    local start_row, _, end_row, _ = node:range()
    local level = get_heading_level(node)
    local text = get_heading_text(node)

    if level then
      table.insert(headings, {
        node = node,
        level = level,
        text = text,
        line = start_row
      })
    end
  end

  -- 按行号排序
  table.sort(headings, function(a, b) return a.line < b.line end)

  -- 查找当前行之前的所有标题
  local relevant_headings = {}
  for _, heading in ipairs(headings) do
    if heading.line <= current_line then
      -- 检查是否已有同级或更高级的标题
      local i = 1
      while i <= #relevant_headings do
        if relevant_headings[i].level >= heading.level then
          table.remove(relevant_headings, i)
        else
          i = i + 1
        end
      end
      table.insert(relevant_headings, heading)
    else
      break
    end
  end

  -- 按级别排序
  table.sort(relevant_headings, function(a, b) return a.level < b.level end)

  return relevant_headings
end

-- 将标题提取到新buffer
function M.extract_headings_to_buffer()
  local headings = M.find_current_headings()

  if #headings == 0 then
    vim.notify("未找到当前行所属的标题", vim.log.levels.WARN)
    return
  end

  -- 创建新buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_name(buf, "Markdown Headings")

  -- 准备标题文本
  local lines = {}
  for _, heading in ipairs(headings) do
    local indent = string.rep("  ", heading.level - 1)
    table.insert(lines, indent .. heading.text)
  end

  -- 设置buffer内容
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- 在新窗口中显示buffer
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)

  -- 设置语法高亮
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  vim.notify("已提取" .. #headings .. "个标题到新buffer", vim.log.levels.INFO)
end

-- 设置命令
function M.setup()
  vim.api.nvim_create_user_command("ExtractHeadings", function()
    M.extract_headings_to_buffer()
  end, {})

  -- 可选：设置快捷键
  vim.api.nvim_set_keymap('n', '<Leader>dh', ':ExtractHeadings<CR>', { noremap = true, silent = true })

  vim.notify("Markdown标题提取器已加载", vim.log.levels.INFO)
end

return M
