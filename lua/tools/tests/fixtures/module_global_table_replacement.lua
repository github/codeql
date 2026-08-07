module("sample")

handlers = {}
local stale = handlers
handlers = {}

function stale.old(value)
  return value
end

function handlers.live(value)
  return value
end

local dynamic_key = ...
handlers[dynamic_key] = function(value)
  return value
end
