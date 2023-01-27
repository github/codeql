import swift

string describe(TypeDecl td) {
  result = "getAliasedType:" + td.(TypeAliasDecl).getAliasedType()
  or
  result = "getABaseType:" + td.(NominalTypeDecl).getABaseType()
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
