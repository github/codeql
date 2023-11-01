import swift

string describe(Type t) {
  result = "getName:" + t.getName()
  or
  result = "getFullName:" + t.getFullName()
  or
  result = "getUnderlyingType:" + t.getUnderlyingType().toString()
  or
  result = "getAliasedType:" + t.(TypeAliasType).getAliasedType().toString()
  or
  result = "getABaseType:" + t.getABaseType().toString()
  or
  result = "getCanonicalType:" + t.getCanonicalType().toString()
}

from VarDecl v, Type t
where
  v.getLocation().getFile().getBaseName() != "" and
  not v.getName() = "self" and
  t = v.getType()
select v, t.toString(), concat(describe(t), ", ")
