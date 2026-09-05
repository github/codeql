local M = {}
local sink = require("merged_sink")

function shellquote(value)
  return value
end

function M.send(value)
  local cleaned = shellquote(value)
  local forwarded
  if condition then
    forwarded = cleaned
  else
    forwarded = value
  end
  sink.send(forwarded)
end

return M
