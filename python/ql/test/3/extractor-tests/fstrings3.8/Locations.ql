import python

from Expr e, Location l
where l = e.getLocation()
select l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn(), e.toString()
