import python

from Call c, AstNode arg, int n, string what
where
  what = "position" and arg = c.getPositionalArg(n)
  or
  what = "named" and arg = c.getNamedArg(n)
select c.getLocation().getStartLine(), what, n, arg.toString()
