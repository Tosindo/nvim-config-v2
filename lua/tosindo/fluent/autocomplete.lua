local config = require 'tosindo.fluent.config'
local utils = require 'tosindo.fluent.utils'
local codestral = require 'tosindo.fluent.api.codestral'
local events = require 'tosindo.fluent.events'

local M = {}

local completion_in_progress = false
local last_cursor_position = nil
local current_buffer = nil
local ns_id = vim.api.nvim_create_namespace 'tosindo_fluent_autocomplete'

local function clear_ghost_text()
  if current_buffer and vim.api.nvim_buf_is_valid(current_buffer) then
    vim.api.nvim_buf_clear_namespace(current_buffer, ns_id, 0, -1)
  end
end

local function get_cursor_position()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  return { row = row, col = col }
end

local function positions_equal(pos1, pos2)
  return pos1.row == pos2.row and pos1.col == pos2.col
end

local function insert_completion(completion)
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify('Invalid buffer', vim.log.levels.ERROR)
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.split(completion, '\n')
  local first_line = lines[1]
  local remaining_lines = vim.list_slice(lines, 2)

  -- Insert the first line
  local current_line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
  local new_line = current_line:sub(1, col) .. first_line .. current_line:sub(col + 1)
  vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { new_line })

  -- Insert remaining lines
  if #remaining_lines > 0 then
    vim.api.nvim_buf_set_lines(bufnr, row, row, false, remaining_lines)
  end

  -- Move cursor to the end of the inserted completion
  vim.api.nvim_win_set_cursor(0, { row + #remaining_lines, col + #first_line })
end

local function abort_completion(err)
  completion_in_progress = false

  if not current_buffer then
    return
  end

  if err then
    vim.api.nvim_exec_autocmds('User', { pattern = events.completion_failed })
  else
    vim.api.nvim_exec_autocmds('User', { pattern = events.completion_processed })
  end

  clear_ghost_text()

  if current_buffer and vim.api.nvim_buf_is_valid(current_buffer) then
    local accept_keymap = vim.fn.maparg(config.options.keymaps.accept, 'i', false, true)
    if accept_keymap.buffer == 1 then
      vim.keymap.del('i', config.options.keymaps.accept, { buffer = current_buffer })
    end

    local reject_keymap = vim.fn.maparg(config.options.keymaps.reject, 'i', false, true)
    if reject_keymap.buffer == 1 then
      vim.keymap.del('i', config.options.keymaps.reject, { buffer = current_buffer })
    end
  end

  current_buffer = nil
end

local function display_ghost_text(completion, row, col)
  if not current_buffer then
    return
  end

  clear_ghost_text()

  local lines = vim.split(completion, '\n')
  local first_line = lines[1]
  local remaining_lines = vim.list_slice(lines, 2)

  vim.notify(first_line)

  -- Display the first line as an overlay
  vim.api.nvim_buf_set_extmark(current_buffer, ns_id, row - 1, col, {
    virt_text = { { first_line, 'Comment' } },
    virt_text_pos = 'overlay',
  })

  -- Insert virtual lines for the remaining lines
  if #remaining_lines > 0 then
    vim.api.nvim_buf_set_extmark(current_buffer, ns_id, row - 1, 0, {
      virt_lines = vim.tbl_map(function(line)
        return { { line, 'Comment' } }
      end, remaining_lines),
    })
  end
end

function M.get_context(max_tokens, prefix_ratio)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- Calculate token limits for prefix and suffix
  local prefix_token_limit = math.floor(max_tokens * prefix_ratio)
  local suffix_token_limit = max_tokens - prefix_token_limit

  -- Get prefix text (all lines before and including the current line up to the cursor)
  local prefix_lines = vim.api.nvim_buf_get_lines(bufnr, 0, row, false)
  prefix_lines[#prefix_lines] = prefix_lines[#prefix_lines]:sub(1, col)
  local full_prefix = table.concat(prefix_lines, '\n')

  -- Get suffix text (rest of the current line and all lines after)
  local suffix_lines = vim.api.nvim_buf_get_lines(bufnr, row - 1, -1, false)
  suffix_lines[1] = suffix_lines[1]:sub(col + 1)
  local full_suffix = table.concat(suffix_lines, '\n')

  -- Truncate prefix and suffix to their respective token limits
  local prefix, prefix_tokens = utils.truncate_text_to_tokens(full_prefix, prefix_token_limit)

  -- If prefix didn't use all its tokens, add the remainder to the suffix limit
  local remaining_tokens = prefix_token_limit - prefix_tokens
  suffix_token_limit = suffix_token_limit + remaining_tokens

  local suffix, _ = utils.truncate_text_to_tokens(full_suffix, suffix_token_limit)

  return prefix, suffix
end

local function trigger_completion()
  if vim.api.nvim_get_mode().mode ~= 'i' then
    abort_completion()
    return
  end

  local current_position = get_cursor_position()
  if completion_in_progress and last_cursor_position and not positions_equal(current_position, last_cursor_position) then
    abort_completion()
    return
  end

  if completion_in_progress then
    return
  end

  vim.api.nvim_exec_autocmds('User', { pattern = events.completion_processing })

  completion_in_progress = true
  last_cursor_position = current_position
  current_buffer = vim.api.nvim_get_current_buf()

  local model_config = config.get_model_config 'codestral'
  local prefix, suffix = M.get_context(model_config.max_input_tokens, model_config.prefix_ratio)

  codestral.complete(prefix, suffix, function(completion)
    vim.schedule(function()
      if not completion_in_progress or vim.api.nvim_get_current_buf() ~= current_buffer then
        abort_completion()
        return
      end

      current_position = get_cursor_position()
      if not positions_equal(current_position, last_cursor_position) then
        abort_completion()
        return
      end

      if completion and #completion > 0 then
        display_ghost_text(completion, current_position.row, current_position.col)

        -- Set up keymaps for accept/reject
        vim.keymap.set('i', config.options.keymaps.accept, function()
          if vim.api.nvim_get_mode().mode ~= 'i' or vim.api.nvim_get_current_buf() ~= current_buffer then
            return
          end
          abort_completion()
          insert_completion(completion)
        end, { buffer = current_buffer, silent = true })

        vim.keymap.set('i', config.options.keymaps.reject, function()
          abort_completion()
        end, { buffer = current_buffer, silent = true })
      else
        abort_completion(true)
      end

      completion_in_progress = false
      vim.api.nvim_exec_autocmds('User', { pattern = events.completion_processed })
    end)
  end)
end

function M.setup()
  local group = vim.api.nvim_create_augroup('TosindoFluent', { clear = true })

  vim.api.nvim_create_autocmd({
    'InsertLeave',
    'InsertCharPre',
    'ModeChanged',
  }, {
    group = group,
    callback = utils.debounce(trigger_completion, config.options.debounce_ms),
  })

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'CursorMovedI' }, {
    group = group,
    callback = abort_completion,
  })

  vim.keymap.set('i', config.options.keymaps.trigger, trigger_completion, { silent = true })

  vim.api.nvim_create_autocmd('BufLeave', {
    group = group,
    callback = abort_completion,
  })
end

return M
