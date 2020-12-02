import cpp

from Variable v, Type t
where v.getType() = t
select v, t, concat(t.getAQlClass(), ", ")
