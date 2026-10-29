import cpp

from Class c, ClassAggregateLiteral al, Field f
where
  c = al.getType() and
  f = c.getAField()
select al, c, f, al.getAFieldExpr(f)
