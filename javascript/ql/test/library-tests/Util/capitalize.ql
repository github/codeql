import semmle.javascript.Util

select capitalize("x"), capitalize("X"), capitalize("xx"), capitalize("XX"), capitalize("Xx"),
  capitalize("xX")
