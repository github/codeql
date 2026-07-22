local M = {}
local sink = require("mixed_sink")

function shellquote(value)
  return value
end

function M.send(value)
  local cleaned = shellquote(value)
  sink.send(cleaned)
end

return M
