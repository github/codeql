import cpp

from Type t
where t.getName().contains("wchar")
select t, concat(t.getAQlClass(), ", "), concat(t.(DerivedType).getBaseType().getAQlClass(), ", ")
