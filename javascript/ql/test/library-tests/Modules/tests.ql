import javascript

query predicate test_BulkReExportDeclarations(BulkReExportDeclaration bred) { any() }

query predicate test_ExportDeclarations(ExportDeclaration ed) { any() }

query predicate test_ExportDefaultDeclarations(ExportDefaultDeclaration edd) { any() }

query predicate test_ExportSpecifiers(ExportSpecifier es, Identifier res0, Identifier res1) {
  res0 = es.getLocal() and res1 = es.getExported()
}

query predicate test_GlobalVariableRef(VarAccess access) {
  access.getVariable() instanceof GlobalVariable
}

query predicate test_ImportDefaultSpecifiers(ImportDefaultSpecifier ids) { any() }

query predicate test_ImportMetaExpr(ImportMetaExpr meta) { any() }

query predicate test_ImportNamespaceSpecifier(ImportNamespaceSpecifier ins) { any() }

query predicate test_ImportSpecifiers(ImportSpecifier is, VarDecl res) { res = is.getLocal() }

query predicate test_Imports(ImportDeclaration id, PathExpr res0, int res1) {
  res0 = id.getImportedPath() and res1 = count(id.getASpecifier())
}

query predicate test_Module_exports(Module m, string name, DataFlow::Node exportValue) {
  exportValue = m.getAnExportedValue(name)
}

query predicate test_NamedImportSpecifier(NamedImportSpecifier nis) { any() }

query predicate test_OtherImports(Import imprt, Module res) {
  not imprt instanceof ImportDeclaration and res = imprt.getImportedModule()
}

query predicate test_ReExportDeclarations(ReExportDeclaration red, ConstantString res) {
  res = red.getImportedPath()
}

query predicate test_getAnImportedModule(string res0, string res1) {
  exists(Module mod |
    res0 = mod.getFile().getRelativePath() and
    res1 = mod.getAnImportedModule().getFile().getRelativePath()
  )
}

query predicate test_getExportedName(ExportSpecifier es, string res) { res = es.getExportedName() }

query predicate test_getImportedName(ImportSpecifier is, string res) { res = is.getImportedName() }

query predicate test_getLocalName(ExportSpecifier es, string res) { res = es.getLocalName() }

query predicate test_getSourceNode(ExportDeclaration ed, string name, DataFlow::Node res) {
  res = ed.getSourceNode(name)
}
