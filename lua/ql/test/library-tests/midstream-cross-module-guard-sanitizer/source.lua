local http = require("neutral.http")
local middle = require("neutral.middle")

local guarded = http.formvalue("guarded")
middle.forward(guarded)

local unguarded = http.formvalue("unguarded")
middle.forward_unrelated(unguarded)
