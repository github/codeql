import swift

string describe(TypeDecl td) {
  result = "getName:" + td.getName()
  or
  result = "getFullName:" + td.getFullName()
  or
  result = "getAliasedType:" + td.(TypeAliasDecl).getAliasedType().toString()
  or
  result = "getABaseType:" + td.getABaseType().toString()
  or
  result = "getABaseTypeDecl:" + td.getABaseTypeDecl().toString()
}

from VarDecl v, TypeDecl td
where
  v.getLocation().getFile().getBaseName() != "" and
  not v.getName() = "self" and
  (
    td = v.getType().(NominalType).getDeclaration() or
    td = v.getType().(TypeAliasType).getDecl()
  )
select v, td.toString(), concat(describe(td), ", ")
