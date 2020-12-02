import cpp

//this query should find the baseType of CC* to be CC, not C.
from DerivedType t, Type baseType
where t.getBaseType() = baseType
select t, baseType
