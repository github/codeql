import javascript

query predicate test_ModuleImportNode(
  DataFlow::ModuleImportNode m, string res0, Identifier use, string res1
) {
  m.flowsToExpr(use) and res0 = m.getPath() and res1 = use.getName()
}
