import cpp

from Expr e, Type t
where t = e.getType()
select e, t.explain(), t.getUnspecifiedType().explain()
