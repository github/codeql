luci = { http = {} }

function luci.http.formvalue(name)
  return name
end

os = {}

function os.execute(command)
end

local sanitizer = require("sanitizer")
local tainted = luci.http.formvalue("cmd")
local cleaned = sanitizer.clean(tainted)
os.execute(cleaned)
