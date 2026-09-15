local http = require("neutral.http")
local sink = require("neutral.sink")

local value = http.formvalue("value")
if tonumber(value) then
  sink.consume(value)
end
