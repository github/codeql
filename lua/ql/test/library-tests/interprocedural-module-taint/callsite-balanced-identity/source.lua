local function identity(value)
  local result = value
  return result
end

local tainted = input()
local tainted_result = identity(tainted)
local clean_result = identity("clean")

return tainted_result, clean_result
