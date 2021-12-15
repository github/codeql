import cpp

from Constructor c, int i, Expr e, string what
where
  e = c.getInitializer(i) and
  what = e.getAQlClass() and
  what.matches("Constructor%Init")
select c, i, what, e, count(e.getAChild()), count(e.getAChild*().(Literal))
