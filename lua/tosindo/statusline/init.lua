local M = {}

local cpl = require 'tosindo.statusline.copilot'

local modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['V'] = 'VISUAL LINE',
  [''] = 'VISUAL BLOCK',
  ['s'] = 'SELECT',
  ['S'] = 'SELECT LINE',
  [''] = 'SELECT BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rv'] = 'VISUAL REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'VIM EX',
  ['ce'] = 'EX',
  ['r'] = 'PROMPT',
  ['rm'] = 'MOAR',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(' %s ', modes[current_mode]):upper()
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = '%#StatusLineAccent#'
  if current_mode == 'n' then
    mode_color = '%#StatuslineAccent#'
  elseif current_mode == 'i' or current_mode == 'ic' then
    mode_color = '%#StatuslineInsertAccent#'
  elseif current_mode == 'v' or current_mode == 'V' or current_mode == '' then
    mode_color = '%#StatuslineVisualAccent#'
  elseif current_mode == 'R' then
    mode_color = '%#StatuslineReplaceAccent#'
  elseif current_mode == 'c' then
    mode_color = '%#StatuslineCmdLineAccent#'
  elseif current_mode == 't' then
    mode_color = '%#StatuslineTerminalAccent#'
  end
  return mode_color
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
  if fpath == '' or fpath == '.' then
    return ' '
  end

  return string.format(' %%<%s/', fpath)
end

local function filename()
  local fname = vim.fn.expand '%:t'
  if fname == '' then
    return ''
  end
  return fname .. ' '
end

local function lsp()
  local count = {}
  local levels = {
    errors = vim.diagnostic.severity.ERROR,
    warnings = vim.diagnostic.severity.WARN,
    info = vim.diagnostic.severity.INFO,
    hints = vim.diagnostic.severity.HINT,
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''

  if count['errors'] ~= 0 then
    errors = ' %#DiagnosticSignError# ' .. count['errors']
  end
  if count['warnings'] ~= 0 then
    warnings = ' %#DiagnosticSignWarning# ' .. count['warnings']
  end
  if count['hints'] ~= 0 then
    hints = ' %#DiagnosticSignHint# ' .. count['hints']
  end
  if count['info'] ~= 0 then
    info = ' %#DiagnosticSignInformation# ' .. count['info']
  end

  return errors .. warnings .. hints .. info .. '%#Normal#'
end

local function filetype()
  return string.format(' %s ', vim.bo.filetype):upper()
end

local function lineinfo()
  if vim.bo.filetype == 'alpha' then
    return ''
  end
  return ' %P %l:%c '
end

local vcs = function()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == '' then
    return ''
  end
  local added = git_info.added and ('%#GitSignsAdd#+' .. git_info.added .. ' ') or ''
  local changed = git_info.changed and ('%#GitSignsChange#~' .. git_info.changed .. ' ') or ''
  local removed = git_info.removed and ('%#GitSignsDelete#-' .. git_info.removed .. ' ') or ''
  if git_info.added == 0 then
    added = ''
  end
  if git_info.changed == 0 then
    changed = ''
  end
  if git_info.removed == 0 then
    removed = ''
  end
  return table.concat {
    ' ',
    added,
    changed,
    removed,
    ' ',
    '%#GitSignsAdd# ',
    git_info.head,
    ' %#Normal#',
  }
end

local copilot_attached = false

local function copilot()
  -- All copilot API calls are blocking before copilot is attached,
  -- To avoid blocking the startup time, we check if copilot is attached
  local copilot_loaded = package.loaded['copilot'] ~= nil
  if not copilot_loaded or not copilot_attached then
    return ' '
  end

  if cpl.is_loading() then
    return ' '
  elseif not cpl.is_enabled() then
    return '󰚩 '
  elseif cpl.is_sleep() then
    return '󰒲 '
  else
    return '󱚡 '
  end
end

_G.status_line_active = function()
  return table.concat {
    '%#Statusline#',
    update_mode_colors(),
    mode(),
    '%#Normal# ',
    copilot(),
    vcs(),
    filepath(),
    filename(),
    '%#Normal#',
    lsp(),
    '%=%#StatusLineExtra#',
    filetype(),
    lineinfo(),
  }
end

function M.inactive()
  return ' %F'
end

function M.short()
  return '%#StatusLineNC#   NvimTree'
end

function M.setup()
  local statusline_group = vim.api.nvim_create_augroup('Statusline', { clear = true })

  local ignore_filetypes = { 'neo-tree', 'fidget' }
  local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

  vim.api.nvim_create_autocmd({
    'WinEnter',
    'BufEnter',
  }, {
    group = statusline_group,
    callback = function()
      if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) or vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
        return
      end

      vim.opt_local.statusline = '%!v:lua.status_line_active()'
      vim.w.has_custom_statusline = 'active'
    end,
  })

  vim.api.nvim_create_autocmd({
    'WinLeave',
    'BufLeave',
  }, {
    group = statusline_group,
    callback = function()
      if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) or vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
        return
      end

      vim.opt_local.statusline = M.inactive()
      vim.w.has_custom_statusline = 'inactive'
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = statusline_group,
    desc = 'Update copilot attached status',
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == 'copilot' then
        copilot_attached = true
        return true
      end
      return false
    end,
  })
end

return M
