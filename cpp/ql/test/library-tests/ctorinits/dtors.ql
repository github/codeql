import cpp

from Destructor d, int i, Expr e, string what
where
  e = d.getDestruction(i) and
  what = e.getAQlClass() and
  what.matches("Destructor%Destruction")
select d, i, what, e, count(e.getAChild())
