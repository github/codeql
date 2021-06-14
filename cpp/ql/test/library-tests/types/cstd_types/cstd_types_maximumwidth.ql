import cpp

from Variable v, MaximumWidthIntegralType t
where v.getType() = t
select v, concat(t.getAQlClass(), ", ")
