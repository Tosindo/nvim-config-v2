local M = {}

-- This table contains common prefixes that often count as a single token
local COMMON_PREFIXES = {
  'un',
  're',
  'in',
  'im',
  'non',
  'dis',
  'over',
  'under',
  'sub',
  'super',
  'inter',
  'intra',
  'pro',
  'anti',
  'auto',
  'bi',
  'co',
  'de',
  'en',
  'ex',
  'extra',
  'hyper',
  'macro',
  'micro',
  'mono',
  'multi',
  'poly',
  'pre',
  'post',
  'semi',
  'sub',
  'trans',
  'tri',
  'ultra',
}

function M.debounce(fn, ms)
  local timer = vim.uv.new_timer()
  return function(...)
    local args = { ... }
    timer:stop()
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule(function()
        fn(unpack(args))
      end)
    end)
  end
end

-- Function to estimate the number of tokens in a string
function M.estimate_tokens(text)
  -- Convert text to lowercase for easier processing
  text = string.lower(text)

  -- Replace common punctuation with spaces
  text = text:gsub('[%p]', ' ')

  -- Split the text into words
  local words = {}
  for word in text:gmatch '%S+' do
    table.insert(words, word)
  end

  local token_count = 0

  for _, word in ipairs(words) do
    -- Check if the word starts with a common prefix
    local prefix_found = false
    for _, prefix in ipairs(COMMON_PREFIXES) do
      if word:sub(1, #prefix) == prefix then
        token_count = token_count + 1
        word = word:sub(#prefix + 1)
        prefix_found = true
        break
      end
    end

    -- If no prefix was found, or there's still content after the prefix
    if not prefix_found or #word > 0 then
      -- Estimate tokens based on word length
      if #word <= 4 then
        token_count = token_count + 1
      else
        token_count = token_count + math.ceil(#word / 4)
      end
    end
  end

  return token_count
end

function M.truncate_text_to_tokens(text, max_tokens)
  local lines = vim.split(text, '\n')
  local truncated_lines = {}
  local token_count = 0

  for _, line in ipairs(lines) do
    local line_tokens = M.estimate_tokens(line)
    if token_count + line_tokens <= max_tokens then
      table.insert(truncated_lines, line)
      token_count = token_count + line_tokens
    else
      break
    end
  end

  return table.concat(truncated_lines, '\n'), token_count
end

return M
