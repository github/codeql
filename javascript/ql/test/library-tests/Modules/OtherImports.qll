import javascript

query predicate test_OtherImports(Import imprt, Module res) {
  not imprt instanceof ImportDeclaration and res = imprt.getImportedModule()
}
