local function fixed(value)
  return value
end

local function open(value)
  return value, value
end

local function consume(...)
  return ...
end

local function run(first, second)
  return consume(fixed(first), open(second))
end

return run
