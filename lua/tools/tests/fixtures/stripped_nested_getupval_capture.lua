local api = require("neutral.api")

local function outer()
  local function inner(value)
    return api.source(value)
  end

  return inner("payload")
end

return outer()
