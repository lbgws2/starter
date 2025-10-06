return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local config = require("nvim-surround.config")
    local get_text_object = function(text_object)
      return function(_)
        if vim.g.loaded_nvim_treesitter then
          return config.get_selection({
            query = { capture = text_object, type = "textobjects" },
          })
        end
      end
    end
    require("nvim-surround").setup({
      surrounds = {
        ["j"] = {
          add = { { "", "" }, { "", "" } },
        },
        ["d"] = {
          add = { "**", "**" },
          find = get_text_object("@markup.strong.markdown_inline"),
          delete = "^(..)().-(..)()$",
        },
        ["l"] = {
          add = { "~~", "~~" },
          find = get_text_object("@markup.strikethrough.markdown_inline"),
          delete = "^(..)().-(..)()$",
        },
        ["c"] = {
          add = { "```", "```" },
          find = get_text_object("@markup.raw.block.markdown"),
          delete = "^(...)().-(...)()$",
        },
      },
      aliases = {
        ["s"] = { "}", "]", ")", ">", '"', "'", "`", "*", "**", "~~" },
      },
    })
  end,
}
