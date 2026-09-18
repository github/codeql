local provider = {}

function provider.source()
  return "value"
end

local function invoke()
  return provider.source()
end

return invoke()
