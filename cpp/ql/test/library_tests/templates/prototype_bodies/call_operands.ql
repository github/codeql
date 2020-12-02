import cpp

from Expr e, int column
where
  exists(Call c | c = e.getParent+() | c.getLocation().getStartLine() = 5) and
  column = e.getLocation().getStartColumn() and
  column > 10 // Excludes the function name token, which isn't represented nicely yet.
select column, e.toString()
