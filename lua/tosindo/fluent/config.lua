local M = {}

local function get_codestral_defaults()
  return {
    prefix_ratio = 0.75,
    max_input_tokens = 20000,
    max_output_tokens = 10000,
    temperature = 0.7,
    model = 'codestral-latest',
  }
end

M.defaults = {
  api_priority = { 'codestral', 'deepseek', 'ollama' },
  debounce_ms = 600,
  keymaps = {
    accept = '<Tab>',
    reject = '<Esc>',
    trigger = '<C-Space>',
    prompt = '<C-i>',
  },
  api_keys = {},
  models = {
    codestral = get_codestral_defaults(),
  },
}

local function parse_env_file()
  local env_file = vim.fn.stdpath 'config' .. '/.env'
  local api_keys = {}

  if vim.fn.filereadable(env_file) == 1 then
    for line_num, line in ipairs(vim.fn.readfile(env_file)) do
      -- Trim whitespace
      line = line:match '^%s*(.-)%s*$'

      -- Skip empty lines and comments
      if line ~= '' and not line:match '^#' then
        local key, value = line:match '^([%w_]+)%s*=%s*(.+)$'
        if key and value then
          -- Remove surrounding quotes if present
          value = value:gsub('^["\'](.-)["\']$', '%1')

          api_keys[key] = value
        end
      end
    end
  end

  return api_keys
end

function M.setup(opts)
  local env_api_keys = parse_env_file()

  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
  M.options.api_keys = vim.tbl_deep_extend('force', M.options.api_keys, env_api_keys)

  for model, default_config in pairs(M.defaults.models) do
    if M.options.models and M.options.models[model] then
      M.options.models[model] = vim.tbl_deep_extend('force', default_config, M.options.models[model])
    else
      M.options.models[model] = default_config
    end
  end
end

function M.get_api_key(key_name)
  return M.options.api_keys[key_name]
end

function M.get_model_config(model_name)
  return M.options.models[model_name]
end

return M
