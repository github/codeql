import cpp

from Variable v, MinimumWidthIntegralType t
where v.getType() = t
select v, concat(t.getAQlClass(), ", ")
