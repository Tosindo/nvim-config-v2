return {
  's1n7ax/nvim-window-picker',
  name = 'window-picker',
  event = 'VeryLazy',
  version = '2.*',
  config = function()
    require('window-picker').setup {
      hint = 'floating-big-letter',

      show_prompt = false,

      filter_rules = {
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = { 'NvimTree', 'neo-tree', 'notify', 'fidget' },

          -- if the file type is one of following, the window will be ignored
          buftype = { 'terminal' },
        },
      },
    }
  end,
}
