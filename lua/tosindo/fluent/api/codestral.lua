local curl = require 'plenary.curl'
local config = require 'tosindo.fluent.config'

local M = {}

function M.complete(prompt, suffix, callback)
  local api_key = config.get_api_key 'MISTRAL_API_KEY'
  if not api_key then
    vim.notify('Mistral API key not found. Please set MISTRAL_API_KEY in your .env file.', vim.log.levels.ERROR)
    return
  end

  local model_config = config.get_model_config 'codestral'
  local url = 'https://codestral.mistral.ai/v1/fim/completions'
  local headers = {
    ['Content-Type'] = 'application/json',
    ['Accept'] = 'application/json',
    ['x-api-key'] = api_key,
    ['Authorization'] = 'Bearer ' .. api_key,
  }

  local data = vim.json.encode {
    model = model_config.model,
    prompt = prompt,
    suffix = suffix,
    max_tokens = model_config.max_output_tokens,
    temperature = model_config.temperature,
  }

  curl.post(url, {
    headers = headers,
    body = data,
    callback = function(response)
      if response.status ~= 200 then
        vim.schedule(function()
          vim.notify('Error calling Codestral API: ' .. response.body, vim.log.levels.ERROR)
        end)
        return
      end

      local ok, result = pcall(vim.json.decode, response.body)
      if not ok then
        vim.schedule(function()
          vim.notify('Error decoding JSON response: ' .. result, vim.log.levels.ERROR)
        end)
        return
      end

      local completion = result.choices[1].message.content
      vim.schedule(function()
        callback(completion)
      end)
    end,
  })
end

return M
