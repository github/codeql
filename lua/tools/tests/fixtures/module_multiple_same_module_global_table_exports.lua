module("sample")

handlers = {}

function handlers.run(value)
  return value
end

function handlers.run(value)
  return value + 1
end

function invoke(value)
  return handlers.run(value)
end
