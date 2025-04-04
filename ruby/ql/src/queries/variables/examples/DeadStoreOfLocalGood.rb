def f(x)
  result = send(x)
	# check for error
  if (result == -1)
    raise "Unable to send, check network."
  end
  waitForResponse
  return getResponse
end