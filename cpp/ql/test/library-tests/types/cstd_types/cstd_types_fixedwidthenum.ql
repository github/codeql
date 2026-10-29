import cpp

from Variable v, FixedWidthEnumType t
where v.getType() = t
select v, concat(t.getAQlClass(), ", ")
