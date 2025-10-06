return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "md", "html" },
    lazy = true,
    -- build = "cd app && npm install",
    keys = {
      { "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", desc = "markdown预览" },
    },
    config = function()
      vim.fn["mkdp#util#install"]()
      --     vim.g.mkdp_browser = "min"
      -- vim.g.mkdp_browser = 'chrome'
      vim.g.mkdp_open_to_the_world = 1
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_refresh = 1
      vim.g.mkdp_filetypes = { "markdown", "md", "html" }
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "8686"
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = { server = "http://localhost:8686" },
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 1,
      }
    end,
    enabled = true,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  }, -- preview markdown files on browser
}
