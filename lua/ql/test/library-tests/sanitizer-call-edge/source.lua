local http = require("neutral.http")
local sink = require("neutral.sink")

local tainted = http.formvalue("value")
sink.doShell("prefix", tainted)
