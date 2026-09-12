local api = require("neutral.api")

local function invoke(value)
  return api.source(value)
end

return invoke("payload")
