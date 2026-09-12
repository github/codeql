local echo = require("sibling_return_echo")
local cleaner = require("sibling_return_cleaner")
local sink = require("sibling_return_sink")

function source()
  return "input"
end

local tainted = source()
sink.send(tainted)
cleaner.send(echo.copy(tainted))
