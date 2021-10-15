import cpp

from Variable v, FixedWidthIntegralType t
where v.getType() = t
select v, concat(t.getAQlClass(), ", ")
