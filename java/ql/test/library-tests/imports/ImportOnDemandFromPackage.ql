import java

query ClassOrInterface getAnImport(ImportOnDemandFromPackage importDecl) {
  result = importDecl.getAnImport()
}

from ImportOnDemandFromPackage importDecl
select importDecl, importDecl.getPackageHoldingImport()
