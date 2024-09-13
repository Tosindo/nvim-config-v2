local M = {}

local config = require 'tosindo.fluent.config'
local codestral = require 'tosindo.fluent.api.codestral'

function M.prompt_completion(prompt, prefix, suffix, selected_text)
  if selected_text ~= '' then
    prefix = prefix .. '\n' .. prompt .. '\nFor the following:\n' .. selected_text .. '\n\nResponse:'
  end

  prefix = prefix .. 'Prompt: ' .. prompt .. '\n\nResponse:'

  codestral.complete(prefix, suffix, function(completion)
    vim.schedule(function()
      if not completion or #completion <= 0 then
        vim.notify 'Empty completion, please try again'
        return
      end

      local lines = vim.split(completion, '\n')
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

      local width = math.min(#prompt + 4, 80)
      local height = math.min(#lines + 2, 20)

      local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = 'minimal',
        border = 'rounded',
      }

      local win = vim.api.nvim_open_win(bufnr, true, opts)

      -- Set up keymaps for accept/reject
      vim.api.nvim_buf_set_keymap(bufnr, 'n', config.options.keymaps.accept, '', {
        callback = function()
          vim.api.nvim_win_close(win, true)
          if selected_text ~= '' then
            local start_pos = vim.fn.getpos "'<"
            local end_pos = vim.fn.getpos "'>"
            vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], lines)
          else
            vim.api.nvim_put(lines, 'l', true, true)
          end
        end,
        noremap = true,
        silent = true,
      })

      vim.api.nvim_buf_set_keymap(bufnr, 'n', config.options.keymaps.reject, '', {
        callback = function()
          vim.api.nvim_win_close(win, true)
        end,
        noremap = true,
        silent = true,
      })
    end)
  end)
end

return M
