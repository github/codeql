local function identity(value)
  local result = value
  return result
end

local tainted = source()
local tainted_result = identity(tainted)
local clean_result = identity("clean")

execute(clean_result)

return tainted_result
