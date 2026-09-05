local api = require("neutral.api")

local function observe()
  return api
end

local function invoke(value)
  return api.source(value)
end

return observe, invoke("payload")
