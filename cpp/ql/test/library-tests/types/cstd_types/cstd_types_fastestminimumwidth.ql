import cpp

from Variable v, FastestMinimumWidthIntegralType t
where v.getType() = t
select v, concat(t.getAQlClass(), ", ")
