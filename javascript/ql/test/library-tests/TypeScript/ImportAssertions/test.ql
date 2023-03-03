import javascript

query Expr getImportAssertionFromImport(ImportDeclaration decl) {
  result = decl.getImportAssertion()
}

query Expr getImportAssertionFromExport(ExportDeclaration decl) {
  result = decl.getImportAssertion()
}

query Expr getImportAttributes(DynamicImportExpr imprt) { result = imprt.getImportAttributes() }

query JSParseError errors() { any() }
