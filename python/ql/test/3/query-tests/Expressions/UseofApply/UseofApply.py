#### UseofApply.ql

# Use of the builtin function `apply` is generally considered bad now that the
# ability to destructure lists of arguments is possible, but we should not flag
# cases where the function is merely named `apply` rather than being the actual
# builtin `apply` function.

def useofapply():

  def foo():
    pass



  # Positive Cases

  # This use of `apply` is a reference to the builtin function and so SHOULD be
  # caught by the query.
  apply(foo, [1])



  # Negative Cases

  # This use of `apply` is a reference to the locally defined function inside of
  # `local`, and so SHOULD NOT be caught by the query.
  def local():
    def apply(f):
      pass
    apply(foo)([1])
