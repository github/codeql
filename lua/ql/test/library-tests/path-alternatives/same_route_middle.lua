local M = {}
local sink = require("same_route_sink")

function shellquote(value)
  return value
end

function M.send(value)
  if condition then
    sink.send(shellquote(value))
  else
    sink.send(value)
  end
end

return M
