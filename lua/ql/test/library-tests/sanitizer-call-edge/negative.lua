local http = require("neutral.http")
local sink = require("neutral.sink")

local tainted = http.formvalue("value")
sink.consume(tainted)
sink.doShell("prefix", "constant")
