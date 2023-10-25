import javascript

query Expr getImportAttributesFromImport(ImportDeclaration decl) {
  result = decl.getImportAttributes()
}

query Expr getImportAttributesFromExport(ExportDeclaration decl) {
  result = decl.getImportAttributes()
}

query Expr getImportOptions(DynamicImportExpr imprt) { result = imprt.getImportOptions() }

query JSParseError errors() { any() }
