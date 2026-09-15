local cleaner = require("mixed_cleaner")
local sink = require("mixed_sink")

function source()
  return "input"
end

local tainted = source()
if condition then
  cleaner.send(tainted)
else
  sink.send(tainted)
end
