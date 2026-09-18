module("sample")

function helper(value)
  return value
end

function helper(value)
  return value + 1
end

function invoke(value)
  return helper(value)
end
