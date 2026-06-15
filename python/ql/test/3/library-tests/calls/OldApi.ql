import python

from Call c, Expr arg, string what
where
  exists(int n | arg = c.getArg(n) and what = n.toString())
  or
  arg = c.getStarargs() and what = "*"
  or
  arg = c.getKwargs() and what = "**"
  or
  exists(Keyword k | c.getAKeyword() = k |
    what = k.getArg() and
    arg = k.getValue()
  )
select c.getLocation().getStartLine(), arg, what
