local M = {}

function M.clean(value)
  local cleaned = shellquote(value)
  return cleaned
end

return M
