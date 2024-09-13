local M = {}

function M.prompt_completion()
  local mode = vim.api.nvim_get_mode().mode
  local selected_text = ''

  local config = require 'tosindo.fluent.config'
  local autocomplete = require 'tosindo.fluent.autocomplete'

  local model_config = config.get_model_config 'codestral'
  local prefix, suffix = autocomplete.get_context(model_config.max_input_tokens, model_config.prefix_ratio)

  if mode == 'v' or mode == 'V' or mode == '' then
    -- Get selected text in visual mode
    local start_pos = vim.fn.getpos "'<"
    local end_pos = vim.fn.getpos "'>"
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
    if #lines == 1 then
      selected_text = lines[1]:sub(start_pos[3], end_pos[3])
    else
      lines[1] = lines[1]:sub(start_pos[3])
      lines[#lines] = lines[#lines]:sub(1, end_pos[3])
      selected_text = table.concat(lines, '\n')
    end
  end

  local prompt = require 'tosindo.fluent.prompt'

  vim.ui.input({ prompt = 'Enter prompt: ' }, function(input)
    if input then
      prompt.prompt_completion(input, prefix, suffix, selected_text)
    end
  end)
end

function M.setup(opts)
  opts = opts or {}
  require('tosindo.fluent.config').setup(opts)
  require('tosindo.fluent.autocomplete').setup()

  local config = require 'tosindo.fluent.config'

  vim.keymap.set('n', config.options.keymaps.prompt, M.prompt_completion, { desc = 'Prompt completion' })
  vim.keymap.set('v', config.options.keymaps.prompt, M.prompt_completion, { desc = 'Prompt completion' })
end

return M
