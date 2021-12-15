import cpp

predicate describe(Type t, string a, string b) {
  a = "getUnspecifiedType()" and
  b = t.getUnspecifiedType().toString()
  or
  a = "PointerType" and
  b = "" and
  t instanceof PointerType
  or
  a = "VoidPointerType" and
  b = "" and
  t instanceof VoidPointerType
  or
  a = "CharPointerType" and
  b = "" and
  t instanceof CharPointerType
  or
  a = "SpecifiedType" and
  b = "" and
  t instanceof SpecifiedType
  or
  a = "getASpecifier()" and
  b = t.getASpecifier().toString()
  or
  a = "isConst()" and
  b = "" and
  t.isConst()
  or
  a = "isVolatile()" and
  b = "" and
  t.isVolatile()
  or
  a = "getBaseType()" and
  b = t.(DerivedType).getBaseType().toString()
}

from Variable v, Type t, string a, string b
where
  t = v.getType() and
  describe(t, a, b)
select v, t.toString(), a, b
