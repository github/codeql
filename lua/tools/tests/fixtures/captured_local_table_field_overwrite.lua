local function send(value)
  return value
end

local transport = { send = send }
transport.send = "disabled"

local function dispatch(value)
  return transport.send(value)
end

return dispatch
