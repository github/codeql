import javascript

query Expr getImportAttributesFromImport(ImportDeclaration decl) {
  result = decl.getImportAttributes()
}

query Expr getImportAttributesFromExport(ExportDeclaration decl) {
  result = decl.getImportAttributes()
}

query Expr getImportAttributes(DynamicImportExpr imprt) { result = imprt.getImportAttributes() }

query JSParseError errors() { any() }
