import cpp

string declaringEnum(EnumConstant c) {
  if exists(c.getDeclaringEnum().toString())
  then result = c.getDeclaringEnum().toString()
  else result = "<none>"
}

from EnumConstant c, string cName
where c.hasName(cName)
select c, cName, count(c.getDeclaringEnum()), declaringEnum(c), count(c.getLocation()),
  count(c.getDefinitionLocation()), count(c.getADeclarationLocation())
