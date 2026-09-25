local function make_table()
  return {}
end

local function read_after_write(value, key)
  local state = make_table()
  state[key] = value
  return state.result
end

return read_after_write
