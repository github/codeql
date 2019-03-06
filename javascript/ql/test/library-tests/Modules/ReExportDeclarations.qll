import semmle.javascript.ES2015Modules

query predicate test_ReExportDeclarations(ReExportDeclaration red, ConstantString res) {
  res = red.getImportedPath()
}
