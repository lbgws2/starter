return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    dependencies = {
      "lbgws2/flash-zh.nvim",
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash-zh").jump({
            chinese_only = false,
            label = {
              after = false,
              before = { 0, 0 },
              uppercase = false,
              format = function(opts)
                if opts.match.label2 ~= nil then
                  return {
                    { opts.match.label1, opts.hl_group },
                    { opts.match.label2, opts.hl_group },
                  }
                end
                return {
                  { opts.match.label1, opts.hl_group },
                }
              end,
            },
            action = function(match, state)
              state:hide()
              if match.label2 ~= nil then
                require("flash").jump({
                  search = { max_length = 0 },
                  highlight = { matches = false },
                  label = {
                    after = false,
                    before = { 0, 0 },
                    format = function(opts)
                      return {
                        { opts.match.label2, opts.hl_group },
                      }
                    end,
                  },
                  matcher = function(win)
                    -- limit matches to the current label
                    return vim.tbl_filter(function(m)
                      return m.label == match.label and m.win == win
                    end, state.results)
                  end,
                  labeler = function(matches)
                    for _, m in ipairs(matches) do
                      ---@diagnostic disable-next-line: undefined-field
                      m.label = m.label2 -- use the second label
                    end
                  end,
                })
              else
                vim.api.nvim_win_call(match.win, function()
                  vim.api.nvim_win_set_cursor(match.win, match.pos)
                end)
              end
            end,
            labeler = function(matches, state)
              local from = vim.api.nvim_win_get_cursor(state.win)
              local dfrom = from[1] * vim.go.columns + from[2]

              table.sort(matches, function(a, b)
                if a.win ~= b.win then
                  local aw = a.win == state.win and 0 or a.win
                  local bw = b.win == state.win and 0 or b.win
                  return aw < bw
                end
                local use_distance = state.opts.label.distance and a.win == state.win
                if use_distance then
                  local da = a.pos[1] * vim.go.columns + a.pos[2]
                  local db = b.pos[1] * vim.go.columns + b.pos[2]
                  return math.abs(dfrom - da) < math.abs(dfrom - db)
                end
                if a.pos[1] ~= b.pos[1] then
                  return a.pos[1] < b.pos[1]
                end
                return a.pos[2] < b.pos[2]
              end)

              if #matches > 0 then
                local dis = matches[1].pos[1] * vim.go.columns + matches[1].pos[2]
                if dis == dfrom then
                  table.remove(matches, 1)
                end
              end

              local labels = state:labels()
              -- 计算 single_num + (#labels - single_num) * #labels >= #matches
              -- single_num 取最大值
              local single_num = math.floor(((#labels * #labels) - #matches) / (#labels - 1))
              -- local double_num = #labels - single_num
              for m, match in ipairs(matches) do
                if m > single_num then
                  match.label1 = labels[math.floor((m - single_num - 1) / #labels) + 1 + single_num]
                  match.label2 = labels[(m - single_num - 1) % #labels + 1]
                  match.label = match.label1
                else
                  match.label1 = labels[(m - 1) % #labels + 1]
                  match.label2 = nil
                  match.label = match.label1
                end
              end
            end,
          })
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = { "o" },
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<C-S>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
    opts = {
      search = {
        multi_window = false,
      },
      label = {
        after = false,
        before = true,
        style = "overlay",
        rainbow = {
          enabled = true,
        },
      },
      modes = {
        char = {
          highlight = {
            backdrop = false,
          },
          char_actions = function(_)
            return {
              [";"] = "next",
              [","] = "prev",
            }
          end,
        },
      },
    },
  },
}
