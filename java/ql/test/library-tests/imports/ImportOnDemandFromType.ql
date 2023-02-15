import java

query ClassOrInterface getAnImport(ImportOnDemandFromType importDecl) {
  result = importDecl.getAnImport()
}

from ImportOnDemandFromType importDecl
select importDecl, importDecl.getTypeHoldingImport()
