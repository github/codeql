local M = {}
local sink = require("sibling_return_sink")

function shellquote(value)
  return value
end

function M.send(value)
  sink.send(shellquote(value))
end

return M
