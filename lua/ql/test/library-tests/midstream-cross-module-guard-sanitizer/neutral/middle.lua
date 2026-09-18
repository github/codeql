local sink = require("neutral.sink")
local M = {}

function M.forward(value)
  if tonumber(value) then
    sink.consume(value)
  end
end

function M.forward_unrelated(value)
  if tonumber("constant") then
    sink.consume(value)
  end
end

return M
