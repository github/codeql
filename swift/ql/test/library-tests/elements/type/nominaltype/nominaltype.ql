import swift

string describe(Type t) {
  result = "getAliasedType:" + t.(TypeAliasType).getAliasedType()
  or
  result = "getABaseType:" + t.(NominalType).getABaseType()
}

from VarDecl v, Type t
where
  v.getLocation().getFile().getBaseName() != "" and
  not v.getName() = "self" and
  t = v.getType()
select v, t.toString(), t.getUnderlyingType(), concat(describe(t), ", ")
