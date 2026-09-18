local exported = {}
local alias = exported

alias.stale = function()
  return "stale"
end

exported = {}
exported.live = function(value)
  return value
end

local key = get_key()
exported[key] = function()
  return "dynamic"
end

return exported
