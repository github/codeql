local http = require("neutral.http")
local shell = require("neutral.shell")

local value = http.formvalue("value")
if tonumber(value) then
  shell.execute(value)
end
