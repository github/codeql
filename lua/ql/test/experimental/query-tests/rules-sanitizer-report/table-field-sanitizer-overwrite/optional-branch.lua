local state = {}

state.command = source()
if condition() then
  state.command = tonumber(state.command)
end
execute(state.command)
