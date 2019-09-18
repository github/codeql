import semmle.javascript.Util

select truncate("X", 0, "y"), truncate("", 2, "y"), truncate("X", 2, "y"), truncate("XX", 2, "y"),
  truncate("XXX", 2, "y")
