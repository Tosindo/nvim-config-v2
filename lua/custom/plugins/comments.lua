--          ╭─────────────────────────────────────────────────────────╮
--          │         Highlight todo, notes, etc in comments          │
--          ╰─────────────────────────────────────────────────────────╯
return {
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'LudoPinelli/comment-box.nvim',
    config = function()
      -- ── vim keymaps ─────────────────────────────────────────────────────
      vim.keymap.set('n', ';ctb', '<Cmd>CBccbox<CR>', { desc = 'Transform comment to boxed title' })
      vim.keymap.set('n', ';ctl', '<Cmd>CBllline<CR>', { desc = 'Transform comment to lined title' })
      vim.keymap.set('n', ';cts', '<Cmd>CBline<CR>', { desc = 'Transform comment to simple line' })
      vim.keymap.set('n', ';ctm', '<Cmd>CBllbox14<CR>', { desc = 'Transform comment to marked' })
      vim.keymap.set('n', ';ctr', '<Cmd>CBd<CR>', { desc = 'Remove comment box transformation' })
    end,
  },
}
