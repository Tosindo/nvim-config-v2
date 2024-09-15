local M = {}

-- Default configuration
M.config = {
  session_dir = vim.fn.stdpath 'data' .. '/sessions/',
  session_file = 'sessions.json',

  auto_close = {
    buftypes = { 'nofile', 'prompt', 'popup' },
    filetypes = { 'neo-tree', 'fidget', 'codecompanion' },
  },
}

-- Custom events
M.events = {
  pre_save = 'SessionPreSave',
  post_save = 'SessionPostSave',
  pre_load = 'SessionPreLoad',
  post_load = 'SessionPostLoad',
}

-- Initialize the plugin
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  vim.fn.mkdir(M.config.session_dir, 'p')

  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = M.save_session,
    desc = 'Automatically save session on exit',
  })

  vim.api.nvim_create_user_command('SessionList', function()
    M.list_sessions_command(opts.args)
  end, {
    nargs = '?',
    complete = function()
      return { 'global' }
    end,
  })

  vim.api.nvim_create_user_command('SessionLoad', function()
    M.load_session_command(opts.args)
  end, { nargs = 1, complete = M.complete_sessions })
end

-- Generate a unique session ID
local function generate_session_id()
  return vim.fn.sha256(tostring(os.time()) .. vim.fn.rand())
end

-- Get current working directory
local function get_cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h')
end

-- Get current git branch
local function get_git_branch()
  local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD 2>/dev/null')[1] or ''
  return (branch == '' or branch == 'HEAD') and 'no-git' or branch
end

-- Load sessions data
local function load_sessions_data()
  local file = io.open(M.config.session_dir .. M.config.session_file, 'r')
  if not file then
    return {}
  end
  local content = file:read '*all'
  file:close()
  return vim.fn.json_decode(content) or {}
end

-- Save sessions data
local function save_sessions_data(data)
  local file = io.open(M.config.session_dir .. M.config.session_file, 'w')
  if not file then
    return
  end
  file:write(vim.fn.json_encode(data))
  file:close()
end

-- Function to close buffers based on auto_close configuration
local function close_auto_close_buffers()
  local closed_buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buftype = vim.api.nvim_get_option_value('buftype', {
      buf = buf,
    })
    local filetype = vim.api.nvim_get_option_value('filetype', {
      buf = buf,
    })

    if vim.tbl_contains(M.config.auto_close.buftypes, buftype) or vim.tbl_contains(M.config.auto_close.filetypes, filetype) then
      table.insert(closed_buffers, {
        buf = buf,
        name = vim.api.nvim_buf_get_name(buf),
        buftype = buftype,
        filetype = filetype,
      })
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  return closed_buffers
end

-- Function to restore closed buffers
local function restore_closed_buffers(closed_buffers)
  for _, buf_info in ipairs(closed_buffers) do
    local new_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(new_buf, buf_info.name)

    vim.api.nvim_set_option_value('buftype', buf_info.buftype, {
      buf = new_buf,
    })

    vim.api.nvim_set_option_value('filetype', buf_info.filetype, {
      buf = new_buf,
    })
  end
end

-- Save current session
function M.save_session()
  vim.api.nvim_exec_autocmds('User', { pattern = M.events.pre_save })

  local closed_buffers = close_auto_close_buffers()

  local cwd = get_cwd()
  local branch = get_git_branch()
  local session_id = generate_session_id()
  local session_path = M.config.session_dir .. session_id .. '.vim'

  -- Save the session
  vim.cmd('mksession! ' .. vim.fn.fnameescape(session_path))

  restore_closed_buffers(closed_buffers)

  -- Update sessions data
  local sessions = load_sessions_data()
  sessions[cwd] = sessions[cwd] or {}
  sessions[cwd][branch] = session_id
  save_sessions_data(sessions)

  vim.api.nvim_exec_autocmds('User', { pattern = M.events.post_save })
end

-- List available sessions
function M.list_sessions(scope)
  local sessions = load_sessions_data()
  local result = {}

  if scope == 'global' then
    for cwd, branches in pairs(sessions) do
      table.insert(result, { cwd = cwd, branches = {} })
      for branch, _ in pairs(branches) do
        table.insert(result[#result].branches, branch)
      end
    end
  else
    local cwd = get_cwd()
    if sessions[cwd] then
      result = { { cwd = cwd, branches = {} } }
      for branch, _ in pairs(sessions[cwd]) do
        table.insert(result[1].branches, branch)
      end
    end
  end

  return result
end

-- Command to list sessions
function M.list_sessions_command(args)
  local scope = args == 'global' and 'global' or 'local'
  local sessions = M.list_sessions(scope)
  local lines = {}

  for _, session in ipairs(sessions) do
    table.insert(lines, 'Directory: ' .. session.cwd)
    for i, branch in ipairs(session.branches) do
      table.insert(lines, string.format('%d) %s', i, branch))
    end
    table.insert(lines, '')
  end

  if #lines == 0 then
    table.insert(lines, 'No sessions found.')
  end

  vim.api.nvim_echo({ { table.concat(lines, '\n'), 'Normal' } }, true, {})
end

-- Load a specific session
function M.load_session(session_identifier)
  vim.api.nvim_exec_autocmds('User', { pattern = M.events.pre_load })

  local sessions = load_sessions_data()
  local cwd = get_cwd()
  local session_id

  if tonumber(session_identifier) then
    -- Load by index
    local index = tonumber(session_identifier)
    local branches = {}
    for branch, _ in pairs(sessions[cwd] or {}) do
      table.insert(branches, branch)
    end
    table.sort(branches)
    if index > 0 and index <= #branches then
      session_id = sessions[cwd][branches[index]]
    end
  else
    -- Load by path:branch
    local path, branch = session_identifier:match '(.+):(.+)'
    if path and branch then
      session_id = sessions[path] and sessions[path][branch]
    end
  end

  if not session_id then
    vim.api.nvim_err_writeln 'Session not found.'
    return
  end

  local session_path = M.config.session_dir .. session_id .. '.vim'
  if vim.fn.filereadable(session_path) == 1 then
    vim.cmd('source ' .. vim.fn.fnameescape(session_path))

    vim.api.nvim_exec_autocmds('User', { pattern = M.events.post_load })
  else
    vim.api.nvim_err_writeln 'Session file not found.'
  end
end

-- Command to load a session
function M.load_session_command(args)
  M.load_session(args)
end

-- Completion function for SessionLoad command
function M.complete_sessions(_, _, _)
  local sessions = load_sessions_data()
  local completions = {}
  local cwd = get_cwd()

  -- Add numbered completions for current directory
  if sessions[cwd] then
    local branches = {}
    for branch, _ in pairs(sessions[cwd]) do
      table.insert(branches, branch)
    end
    table.sort(branches)
    for i, _ in ipairs(branches) do
      table.insert(completions, tostring(i))
    end
  end

  -- Add global completions
  for path, branches in pairs(sessions) do
    for branch, _ in pairs(branches) do
      table.insert(completions, path .. ':' .. branch)
    end
  end

  return completions
end

return M
