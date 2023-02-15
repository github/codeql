import java

query Member getAMemberImport(ImportStaticTypeMember importDecl) {
  result = importDecl.getAMemberImport()
}

query MemberType getATypeImport(ImportStaticTypeMember importDecl) {
  result = importDecl.getATypeImport()
}

query Method getAMethodImport(ImportStaticTypeMember importDecl) {
  result = importDecl.getAMethodImport()
}

query Field getAFieldImport(ImportStaticTypeMember importDecl) {
  result = importDecl.getAFieldImport()
}

from ImportStaticTypeMember importDecl
select importDecl, importDecl.getTypeHoldingImport(), importDecl.getName()
