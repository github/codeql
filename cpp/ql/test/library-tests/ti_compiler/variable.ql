import cpp

from Variable v, Type t
where t = v.getType()
select v, t, t.explain()
