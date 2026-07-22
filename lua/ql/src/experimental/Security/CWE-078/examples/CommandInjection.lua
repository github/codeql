local requested_action = luci.http.formvalue("action")

-- BAD: external data becomes part of a shell command.
os.execute("service " .. requested_action .. " restart")

local commands = {
  status = "service app status",
  restart = "service app restart"
}

-- GOOD: external data selects a fixed command.
local command = commands[requested_action]
if command then
  os.execute(command)
end
