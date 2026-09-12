function invoke(value)
  local sample = require("sample")
  return sample.handlers.run(value)
end

function missing(value)
  local sample = require("sample")
  return sample.handlers.missing(value)
end

function dynamic(value, dynamic_key)
  local sample = require("sample")
  return sample.handlers[dynamic_key](value)
end
