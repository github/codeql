import java

query Member getAMemberImport(ImportStaticOnDemand importDecl) {
  result = importDecl.getAMemberImport()
}

query MemberType getATypeImport(ImportStaticOnDemand importDecl) {
  result = importDecl.getATypeImport()
}

query Method getAMethodImport(ImportStaticOnDemand importDecl) {
  result = importDecl.getAMethodImport()
}

query Field getAFieldImport(ImportStaticOnDemand importDecl) {
  result = importDecl.getAFieldImport()
}

from ImportStaticOnDemand importDecl
select importDecl, importDecl.getTypeHoldingImport()
