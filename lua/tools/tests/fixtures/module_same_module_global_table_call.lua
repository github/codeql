module("sample")

handlers = {}

function handlers.run(value)
  return value
end

function invoke(value)
  return handlers.run(value)
end
