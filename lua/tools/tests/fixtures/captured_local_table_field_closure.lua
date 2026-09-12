local function send(value)
  return value
end

local transport = { send = send }

local function dispatch(value)
  return transport.send(value)
end

return dispatch
