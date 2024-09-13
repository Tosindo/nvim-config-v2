return {
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        ignore_empty_message = true,
        display = {
          render_limit = 5,
        },
      },

      notification = {
        override_vim_notify = true,
      },
    },
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
}
