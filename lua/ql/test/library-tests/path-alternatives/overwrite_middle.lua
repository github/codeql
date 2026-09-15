local M = {}
local sink = require("overwrite_sink")

function shellquote(value)
  return value
end

function M.send(value)
  local checked = shellquote(value)
  if checked then
    checked = value
    sink.send(checked)
  end
end

return M
