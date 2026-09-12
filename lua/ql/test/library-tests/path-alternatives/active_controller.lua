local sink = require("active_sink")

function source()
  return "input"
end

local tainted = source()
sink.send(tainted)
