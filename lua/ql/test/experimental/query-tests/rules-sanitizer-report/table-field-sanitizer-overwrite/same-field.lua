local state = {}

state.command = source()
if condition() then
  state.command = tonumber(state.command)
else
  state.command = shellquote(state.command)
end
execute(state.command)
