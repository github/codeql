import cpp

from Type t, string baseType1, string baseType2, string unsignedInt, string unsignedIntegral
where
  (if t.(IntType).isUnsigned() then unsignedInt = "unsigned int" else unsignedInt = "") and
  (
    if t.(IntegralType).isUnsigned()
    then unsignedIntegral = "unsigned integral"
    else unsignedIntegral = ""
  ) and
  (
    if exists(t.(ArrayType).getBaseType())
    then baseType1 = t.(ArrayType).getBaseType().toString()
    else baseType1 = ""
  ) and
  if exists(t.(DerivedType).getBaseType())
  then baseType2 = t.(DerivedType).getBaseType().toString()
  else baseType2 = ""
select t.toString(), concat(t.getAQlClass(), ", "), baseType1, baseType2, unsignedInt,
  unsignedIntegral
