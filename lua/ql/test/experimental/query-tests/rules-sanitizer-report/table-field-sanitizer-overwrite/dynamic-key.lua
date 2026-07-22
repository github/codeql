local state = {}

state.command = source()
if condition() then
  state[get_key()] = tonumber(state.command)
end
execute(state.command)
