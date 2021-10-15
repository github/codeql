import cpp

from Type t
where t.getName().matches("%wchar%")
select t, concat(t.getAQlClass(), ", "), concat(t.(DerivedType).getBaseType().getAQlClass(), ", ")
