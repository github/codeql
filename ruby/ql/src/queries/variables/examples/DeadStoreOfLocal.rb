def f(x)
  result = send(x)
  waitForResponse
  return getResponse
end