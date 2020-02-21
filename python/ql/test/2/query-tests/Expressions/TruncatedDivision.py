#### TruncatedDivision.ql

# NOTE: The following test case will only work under Python 2.

# NOTE: While there are other files that have the same matching examples, this
# example file tries to explain the motivation of each example. Hopefully it's
# fine to have multiple such files.

# Truncated division occurs when two integers are divided. This causes the
# fractional part, if there is one, to be discared. So for example, `2 / 3` will
# evaluate to `0` instead of `0.666...`.

def truncated_division():

  def average(l):
    return sum(l) / len(l)



  ## Negative Cases

  # This case is good, and is a minimal obvious case that should be good. It
  # SHOULD NOT be found by the query.
  print(3.0 / 2.0)

  # This case is good, because the sum is `3.0`, which is a float, and will not
  # truncate. This case SHOULD NOT be found by the query.
  print(average([1.0, 2.0]))



  ## Positive Cases

  # This case is bad, and is a minimal obvious case that should be bad. It
  # SHOULD be found by the query.
  print(3 / 2)

  # This case is bad, because the sum is `3`, which is an integer, and will
  # truncate when divided by the length `2`. This case SHOULD be found by the
  # query.
  #
  # NOTE (2020-02-20):
  # The current version of the Value/pointsTo API doesn't permit this detection,
  # unfortunately, but we preserve this example in the hopes that future
  # versions will catch it. That will necessitate changing the expected results.
  print(average([1,2]))
