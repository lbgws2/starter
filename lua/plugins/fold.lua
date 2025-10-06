-- https://github.com/kevinhwang91/nvim-ufo
-- 另外一个折叠插件
return {
  --https://github.com/bbjornstad/neostrix.nvim/blob/5bd88b280b1e453235ce5c565488afb8b572d205/lua/plugins/folding.lua#L101
  "bbjornstad/pretty-fold.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("pretty-fold").setup({
      sections = {
        left = {
          "content",
        },
        right = {
          " ",
          "number_of_folded_lines",
          ": ",
          "percentage",
          " ",
          function(config)
            return config.fill_char:rep(3)
          end,
        },
      },
      fill_char = "•",
      remove_fold_markers = true,
      keep_indentation = true,
      -- Possible values:
      -- "delete" : Delete all comment signs from the fold string.
      -- "spaces" : Replace all comment signs with equal number of spaces.
      -- false    : Do nothing with comment signs.
      process_comment_signs = "spaces",
      comment_signs = {},
      add_close_pattern = true, -- true, 'last_line' or false
      matchup_patterns = {
        { "{",  "}" },
        { "%(", ")" },
        { "%[", "]" },
      },
      ft_ignore = { "neorg", "TelescopeResults", "ToggleTerm", "Noice", "sagaoutline", "dashboard" },
    })
    require("pretty-fold").ft_setup("lua", {
      matchup_patterns = {
        { "^%s*if",        "end" },
        { "^%s*for",       "end" },
        { "function%s*%(", "end" },
        { "{",             "}" },
        { "%(",            ")" },
        { "%[",            "]" },
      },
    })
  end,
}
