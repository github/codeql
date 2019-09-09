import cpp

from Variable v, Type t
where t = v.getType()
select v, t.explain(), count(Type u | u = v.getType())
