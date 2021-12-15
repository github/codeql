import cpp

from TypedefType t, Type u
where u = t.getBaseType()
select t, u, concat(u.getAQlClass(), ", ")
