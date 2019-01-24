import javascript

from CallExpr c, Expr arg
where
  c.getCalleeName() = "DUMP" and
  arg = c.getArgument(0)
select arg, arg.analyze().getAValue()
