import semmle.javascript.ES2015Modules

query predicate test_Imports(ImportDeclaration id, PathExprInModule res0, int res1) {
  res0 = id.getImportedPath() and res1 = count(id.getASpecifier())
}
