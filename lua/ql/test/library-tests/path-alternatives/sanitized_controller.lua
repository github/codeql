local cleaner = require("sanitized_cleaner")
local sink = require("sanitized_sink")

function source()
  return "input"
end

local tainted = source()
sink.send(cleaner.clean(tainted))
