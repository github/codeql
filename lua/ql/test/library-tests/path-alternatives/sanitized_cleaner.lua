local M = {}

function shellquote(value)
  return value
end

function M.clean(value)
  local cleaned = shellquote(value)
  return cleaned
end

return M
