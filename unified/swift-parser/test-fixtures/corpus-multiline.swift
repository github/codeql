let message = """
    first line

    next \(value)
      indented
    """
let raw = #"""
  hello \#(name)
  raw \n
  """#
let escapes = "newline \n tab \t carriage \r raw \\(notInterpolation)"
