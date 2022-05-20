import javascript

query predicate capitalize(string cap, string s) {
  s = ["x", "X", "xx", "XX", "Xx", "xX"] and
  cap = capitalize(s)
}

query predicate describeExpression(Expr e, string description) {
  description = describeExpression(e)
}

query predicate test_pluralize(string res, int num) {
  num = [0, 1, 2, -1] and
  res = pluralize("x", num)
}

select truncate("X", 0, "y"), truncate("", 2, "y"), truncate("X", 2, "y"), truncate("XX", 2, "y"),
  truncate("XXX", 2, "y")
