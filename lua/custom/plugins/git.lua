return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
      'echasnovski/mini.pick', -- optional
    },
    config = function()
      local neogit = require 'neogit'

      neogit.setup {}

      vim.keymap.set('n', ';ng', function()
        neogit.open()
      end, { desc = 'Open Neogit' })
    end,
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      -- OR 'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup {
        default_to_projects_v2 = true,
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
  },
  {
    'rhysd/git-messenger.vim',
    config = function()
      vim.keymap.set('n', ';gm', function()
        vim.cmd 'GitMessenger'
      end, { desc = 'Open Git Messenger' })
    end,
  },
  {
    'aaronhallaert/advanced-git-search.nvim',
    cmd = { 'AdvancedGitSearch' },
    config = function()
      -- optional: setup telescope before loading the extension
      require('telescope').setup {
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            -- Browse command to open commits in browser. Default fugitive GBrowse.
            -- {commit_hash} is the placeholder for the commit hash.
            browse_command = 'GBrowse {commit_hash}',
            -- when {commit_hash} is not provided, the commit will be appended to the specified command seperated by a space
            -- browse_command = "GBrowse",
            -- => both will result in calling `:GBrowse commit`

            -- fugitive or diffview
            diff_plugin = 'diffview',
            -- customize git in previewer
            -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
            git_flags = {},
            -- customize git diff in previewer
            -- e.g. flags such as { "--raw" }
            git_diff_flags = {},
            -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
            show_builtin_git_pickers = false,
            entry_default_author_or_date = 'author', -- one of "author" or "date"
          },
        },
      }

      require('telescope').load_extension 'advanced_git_search'
    end,
    dependencies = {
      {
        'nvim-telescope/telescope.nvim',
        -- to show diff splits and open commits in browser
        'tpope/vim-fugitive',
        -- to open commits in browser with fugitive
        'tpope/vim-rhubarb',
        -- optional: to replace the diff from fugitive with diffview.nvim
        -- (fugitive is still needed to open in browser)
        'sindrets/diffview.nvim',
      },
    },
  },
}
