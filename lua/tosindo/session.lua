local M = {}

--- Auto close settings
---@class AutoClose
---@field buftypes? string[] Buftypes that will be auto-closed before saving.
---@field filetypes? string[] Filetypes that will be auto-closed before saving.

--- Configuration for the session plugin
---@class Config
---@field session_dir? string The directory to store session info.
---@field session_file? string The file (within the session_dir) that contains the link between CWD and Git Branches and a session file.
---@field auto_close? AutoClose the auto close settings

---@alias StoredSessions table<string, table<string, string>> Session data stored in the JSON link file
---@alias ClosedBuffers table<number, { buf: string, name: string, buftype: string, filetype: string }> Buffers auto closed to avoid errors when loading a session

---@type Config
M.config = {
  session_dir = vim.fn.stdpath 'data' .. '/sessions/',
  session_file = 'sessions.json',

  auto_close = {
    buftypes = { 'nofile', 'prompt', 'popup' },
    filetypes = { 'neo-tree', 'fidget', 'codecompanion' },
  },
}

---@enum Events
M.events = {
  pre_save = 'SessionPreSave',
  post_save = 'SessionPostSave',
  pre_load = 'SessionPreLoad',
  post_load = 'SessionPostLoad',
}

--- Setup the session manager
---@param opts Config
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  vim.fn.mkdir(M.config.session_dir, 'p')

  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = M.save_session,
    desc = 'Automatically save session on exit',
  })

  vim.api.nvim_create_user_command('SessionList', function(o)
    M.list_sessions_command(o.args)
  end, {
    nargs = '?',
    complete = function()
      return { 'global' }
    end,
  })

  vim.api.nvim_create_user_command('SessionLoad', function(o)
    M.load_session_command(o.args)
  end, { nargs = 1, complete = M.complete_sessions })

  M.clear_unlinked_sessions()
end

--- Generate a unique session ID
---@return string
local function generate_session_id()
  return vim.fn.sha256(tostring(os.time()) .. vim.fn.rand())
end

--- Get current working directory
---@return string
local function get_cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h')
end

--- Get current git branch
---@return string
local function get_git_branch()
  local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD 2>/dev/null')[1] or ''
  return (branch == '' or branch == 'HEAD') and 'no-git' or branch
end

--- Load sessions data
---@return StoredSessions
local function load_sessions_data()
  local file = io.open(M.config.session_dir .. M.config.session_file, 'r')
  if not file then
    return {}
  end
  local content = file:read '*all'
  file:close()
  return vim.fn.json_decode(content) or {}
end

--- Save sessions data
---@param data StoredSessions
local function save_sessions_data(data)
  local file = io.open(M.config.session_dir .. M.config.session_file, 'w')
  if not file then
    return
  end
  file:write(vim.fn.json_encode(data))
  file:close()
end

--- Function to close buffers based on auto_close configuration
---@return ClosedBuffers
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

--- Function to restore closed buffers
---@param closed_buffers ClosedBuffers
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

--- Save current session
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

--- List available sessions
---@param scope 'global'|'local'|nil
---@return table<number,{cwd: string, branches: string[]}>
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
    local branch = get_git_branch()
    if sessions[cwd] then
      result = { { cwd = cwd, branches = {} } }
      for br, _ in pairs(sessions[cwd]) do
        table.insert(result[1].branches, br)
      end

      table.sort(result[1].branches, function(a)
        return a == branch
      end)
    end
  end
  return result
end

--- Command to list sessions
--- @param args any
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

--- Load a specific session
---@param session_identifier string|number
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

--- Command to load a session
---@param args any
function M.load_session_command(args)
  M.load_session(args)
end

--- Completion function for SessionLoad command
---@return string[]
function M.complete_sessions()
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

--- Clear sessions with no link, to save space.
function M.clear_unlinked_sessions()
  local nio = require 'nio'

  nio.run(function()
    local sessions = load_sessions_data()

    local valid_session_files = {
      M.config.session_file,
    }

    for _, branches in pairs(sessions) do
      for _, file in pairs(branches) do
        table.insert(valid_session_files, file .. '.vim')
      end
    end

    local _, dir = nio.uv.fs_opendir(M.config.session_dir, 1000)

    if dir == nil then
      return
    end

    --- @type string|nil, {type:string, name:string}[]|nil
    local _, files = nio.uv.fs_readdir(dir)

    if files == nil then
      return
    end

    for _, file in pairs(files) do
      for _, valid_session_file in pairs(valid_session_files) do
        if file.type == 'file' and file.name == valid_session_file then
          goto continue
        end
      end

      local path = vim.fn.resolve(M.config.session_dir .. '/' .. file.name)
      if path ~= nil then
        nio.uv.fs_unlink(path)
      end

      ::continue::
    end

    nio.uv.fs_closedir(dir)
  end)
end

return M
