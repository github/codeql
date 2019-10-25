/**
 * @name Fields
 * @kind table
 */

import cpp

predicate nameCheck(Declaration d) {
  count(d.toString()) = 1 and
  count(string s | d.hasName(s)) = 1 and
  d.hasName(d.toString())
}

string accessType(Field f) {
  f.isPublic() and result = "public"
  or
  f.isProtected() and result = "protected"
  or
  f.isPrivate() and result = "private"
}

string fieldType(Field f) {
  result = f.getType().getAQlClass() and
  (
    result.matches("%Type") or
    result = "Enum"
  )
}

string pointedType(Field f) {
  if f.getType() instanceof PointerType
  then result = f.getType().(PointerType).getBaseType().toString()
  else result = ""
}

from Class c, Field f
where
  f.getDeclaringType() = c and
  c.getAField() = f and
  nameCheck(c) and
  nameCheck(f)
select c, f, accessType(f), fieldType(f), pointedType(f)
