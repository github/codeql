local state = {}

state.command = source()
if condition() then
  state.other = tonumber(state.command)
else
  state.other = shellquote(state.command)
end
execute(state.command)
