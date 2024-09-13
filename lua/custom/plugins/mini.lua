-- Collection of various small independent plugins/modules
return {
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    local custom_header = {
      '      |\\__/,|   (`\\                          ',
      '    _.|o o  |_   ) )                           ',
      '   (((---(((-------                            ',
      '  /==/,  -      , -\\                        ',
      '  \\==\\.-.  -    ,-./                       ',
      '   `--`\\==\\-   \\                       ',
      '        \\==\\_   \\         ^~^  ,              ',
      "        |==|-   -|       ('Y') )     ^~^  *   ",
      "        |==|,   -|        / | )     ('Y') $       ",
      '        /==/   -/        /  \\/      /   \\/  ',
      '        `--`----`       (\\|||/)    (\\|||/) ',
      ' ',
      ' ',
      ' ',
      ' ',
    }

    local starter = require 'mini.starter'
    local session = require 'tosindo.session'

    -- Custom function to create session items
    local function get_session_items()
      local sessions = session.list_sessions()
      local items = {}

      for _, sess in ipairs(sessions) do
        for _, branch in ipairs(sess.branches) do
          table.insert(items, {
            name = string.format('%s', branch),
            action = function()
              session.load_session(sess.cwd .. ':' .. branch)
            end,
            section = 'Sessions',
          })
        end
      end

      return items
    end

    starter.setup {
      evaluate_single = true,
      autoopen = true,

      header = table.concat(custom_header, '\n'),
      items = {
        get_session_items(),
        starter.sections.recent_files(10, true),
        starter.sections.builtin_actions(),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.indexing('all', { 'Builtin actions' }),
        starter.gen_hook.aligning('center', 'center'),
      },
    }

    require('mini.pairs').setup()
  end,
}
