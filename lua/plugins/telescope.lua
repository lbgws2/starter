return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { 'dhruvasagar/vim-prosession' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },                        -- for better pop-up integration
      { 'debugloop/telescope-undo.nvim' },              -- see undo tree in telescope
      { 'nvim-telescope/telescope-media-files.nvim' },  -- see images in telescope
      { 'nvim-telescope/telescope-file-browser.nvim' }, -- for better file navigation
      { 'nvim-telescope/telescope-bibtex.nvim' },       -- to find bibliography
      { 'rcarriga/nvim-notify' },                       -- for the notify source
      { 'folke/todo-comments.nvim' },                   -- for todo source
      { 'crispgm/telescope-heading.nvim' },             -- to jump between headings in latex (and other filetypes)
      { 'nvim-telescope/telescope-dap.nvim' },          -- for debugging navigation
      { 'JoseConseco/telescope_sessions_picker.nvim' }, -- for picking sessions

      -- {'/folke/trouble.nvim'}                         -- for picking diagnostics
    },
    keys = {
      -- find current. PRIVILEGED: space space for efficienty of file switching and navigating
      { '<space><space>', "<cmd>Telescope file_browser<cr>",                          desc = "Browse Current Dir" },
      -- find [f]iles
      { '<space>ff',      function() require('telescope.builtin').find_files() end,   desc = "[f]ind [f]iles in cwd" },
      -- find [g]rep
      { '<space>fg',      function() require('telescope.builtin').live_grep() end,    desc = '[f]ind [g]rep' },
      -- find [s]essions
      { '<space>fs',      "<cmd>Telescope prosession<cr>",    desc = '[f]ind [s]essions' },
      -- find [f]ind [word] under cursor in [c]wd
      { '<space>fwc',      "<cmd>Telescope grep_string<cr>",        desc = '[f]ind [word] under cursor in [c]wd' },
      -- find [m]arker
      { '<space>fm',      function() require('telescope.builtin').marks() end,        desc = '[f]ind [m]ark' },
      -- find [u]ndo
      { '<space>fu',      function() require('telescope').extensions.undo.undo() end, desc = '[f]ind [u]ndo' },

      -- control f feature works just like in any other text editor
      {
        '<space>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes')
            .get_dropdown())
        end,
        desc = 'Fuzzily search in current buffer'
      },
      -- NOTE: commented bc conficts with <c-f> for scrolling in lsp pum
      -- { '<c-f>', function() require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown())end , { desc = 'Fuzzily search in current buffer' }},
      -- find [b]uffer
      { '<space>fb', function() require('telescope.builtin').buffers() end, desc = '[f]ind [b]uffer' },
      -- find [o]ld
      { '<space>fo', function() require('telescope.builtin').oldfiles() end, desc = '[f]ind [o]ld files' },
      -- find [h]elp
      { '<space>fh', function() require('telescope.builtin').help_tags() end, desc = '[f]ind [h]elp tags' },
      -- find [c]ommands
      { '<space>fc', function() require('telescope.builtin').commands() end, desc = "[f]ind [c]ommands" },
      -- find [c]ommands
      { '<space>fk', function() require('telescope.builtin').keymaps() end, desc = "[f]ind [k]eymaps" },
      -- find [t]odo's
      { '<space>ft', "<cmd>TodoTelescope<cr>", desc = "[f]ind [t]odo\'s" },
      -- find [n]otifications
      { '<space>fn', "<cmd>Telescope notify<cr>", desc = '[f]ind [n]otifications' },
      -- find [B]ookmarks
      { '<space>fB', "<cmd>Telescope bookmarks<cr>", desc = '[f]ind [B]ookmarks' },
      { '<space>fG', function() require('telescope.builtin').git_status({ cwd = '.', use_file_path = true }) end, desc = "[f]ind [G]it changes" },

      --  ╔══════════════════════════════════════════════════════════╗
      --  ║                grepping special locations                ║
      --  ╚══════════════════════════════════════════════════════════╝

      -- find [g]rep all neovim config
      { '<space>gC', function() require('telescope.builtin').live_grep({ search_dirs = { '~/.config/nvim/' } }) end, desc = '[g]rep [c]onfiguration' },
      -- find [g]rep plugins
      { '<space>gp', function() require('telescope.builtin').live_grep({ search_dirs = { '~/.config/nvim/lua/plugins/' } }) end, desc = '[g]rep [p]lugins' },
      -- find [g]rep plugins
      { '<space>gc', function() require('telescope.builtin').live_grep({ search_dirs = { '~/.config/nvim/lua/configs/' } }) end, desc = '[g]rep [c]onfigs' },
      -- grep current directory
      { '<space>gg', function() require('telescope.builtin').live_grep() end, desc = 'grep current directory' },


      --  ╔══════════════════════════════════════════════════════════╗
      --  ║                   special navigations                    ║
      --  ╚══════════════════════════════════════════════════════════╝

      -- [t]able of content
      { '<space>t', "<cmd>Telescope heading<cr>", desc = '󰉸 table of content' },
      -- control [v] history
      { '<c-s-v>', '<cmd>Telescope neoclip theme=cursor<cr>', mode = "i", {} },
      --  find [t]odo's
      { '<c-s-f>', "<cmd>Telescope command_history<cr>", mode = { "c" } },
      { '<space>h', "<cmd>Telescope harpoon marks<cr>", desc = 'harpoon' },

      --  ╔══════════════════════════════════════════════════════════╗
      --  ║                           LSP                            ║
      --  ╚══════════════════════════════════════════════════════════╝

      -- find [g]rep all neovim config
      { '<space>lr', function() require('telescope.builtin').lsp_references() end, desc = '[l]sp [r]eferences' },
      { '<space>ld', function() require('telescope.builtin').lsp_definitions() end, desc = '[l]sp [d]efinitions' },
      { '<space>lo', "<cmd>Telescope lsp_document_symbols<cr>", desc = '[l]sp [o]outline' },
      -- {'<space>lo',function() require('telescope.builtin').lsp_document_symbols() end, desc = '[l]sp [o]outline'},
      --  ╔═════════════════════════════════════════════════════════╗
      --  ║                                                         ║
      --  ║                       diagnostics                       ║
      --  ║                                                         ║
      --  ╚═════════════════════════════════════════════════════════╝

      -- for all diagnostics

      { '<space>dd', function() require('telescope.builtin').diagnostics() end, desc = '[d]iagnostics' },
      { '<space>de', function() require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.ERROR }) end, desc = '[d]iagnostics [e]rror' },
      { '<space>dw', function() require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.WARN }) end, desc = '[d]iagnostics [e]rror' },
      { '<space>di', function() require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.INFO }) end, desc = '[d]iagnostics [i]nfo' },
      { '<space>dh', function() require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.HINT }) end, desc = '[d]iagnostics [h]int' },

      --  ╔══════════════════════════════════════════════════════════╗
      --  ║                         debugging                        ║
      --  ╚══════════════════════════════════════════════════════════╝

      { '<space>Dc', function() require 'telescope'.extensions.dap.commands() end, desc = '[d]ebug [c]ommands' },
      { '<space>DC', function() require 'telescope'.extensions.dap.configurations() end, desc = '[d]ebug [C]onfiguration' },
      { '<space>Db', function() require 'telescope'.extensions.dap.list_breakpoints() end, desc = '[d]ebug [b]reakpoints' },
      { '<space>Dv', function() require 'telescope'.extensions.dap.variables() end, desc = '[d]ebug [v]ariables' },
      { '<space>Df', function() require 'telescope'.extensions.dap.frames() end, desc = '[d]ebug [f]rames' },

      --  ╔══════════════════════════════════════════════════════════╗
      --  ║                            --                            ║
      --  ║                      miscellaneous                       ║
      --  ║                            --                            ║
      --  ╚══════════════════════════════════════════════════════════╝

      { '<space>C', function() require('telescope.builtin').colorscheme() end, desc = '[C]olorscheme' },
      { '<space>r', function() require('telescope.builtin').resume() end, desc = '[R]esume' },
      { '<c-s-c>', '<cmd>Telescope bibtex theme=cursor<cr>', mode = "i", desc = 'citation from bibtex' },
      { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find fuzzy=false<cr>", desc = "在当前文件中查找" },
      { "<leader>ut", "<cmd>Telescope ultisnips<cr>", desc = "ultisnips telescope" },

      {
        "<leader>gb",
        function()
          require("telescope.builtin").git_branches()
        end,
        desc = "Git checkout",
      },
    },
    opts = {
      extensions = {
     
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
        media_files = {
          filetypes = { "png", "jpg", "mp4", "webm", "pdf" },
          find_cmd = "rg",
        },

        project = {
          base_dirs = { { path = "~", max_depth = 4 } },
        },
      },
    },
    config = function(_, opts)
	local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },

          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["?"] = actions.which_key,
          },
        },
          -- configure to use ripgrep
          vimgrep_arguments = {
            "rg",
            "--follow",        -- Follow symbolic links
            "--hidden",        -- Search for hidden files
            "--no-heading",    -- Don't group matches by each file
            "--with-filename", -- Print the file path with the matched lines
            "--line-number",   -- Show line numbers
            "--column",        -- Show column numbers
            "--smart-case",    -- Smart case search

            -- Exclude some patterns from search
            "--glob=!**/.git/*",
            "--glob=!**/.idea/*",
            "--glob=!**/.vscode/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/yarn.lock",
            "--glob=!**/package-lock.json",
          },
        },
        undo = {
          side_by_side = true,
          layout_strategy = 'vertical',
          -- layout_strategy = "horizontal",
          layout_config = {
            preview_height = 0.7,
            -- preview_width = 70,
            vertical = { width = 0.7 },
            horizontal = { width = 0.7 },
          },
          -- telescope-undo.nvim config, see below
        },
        pickers = {
          find_files = {
            hidden = true,

            -- needed to exclude some files & dirs from general search

            -- when not included or specified in .gitignore
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob=!**/.git/*",
              "--glob=!**/.idea/*",
              "--glob=!**/.vscode/*",
              "--glob=!**/build/*",
              "--glob=!**/dist/*",
              "--glob=!**/yarn.lock",
              "--glob=!**/package-lock.json",
            },
          },
        },
      })
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("project")
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("prosession")



      -- require("neoclip").setup()
    end,
  },
}
