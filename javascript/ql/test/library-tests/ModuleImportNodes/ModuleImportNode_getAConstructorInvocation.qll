import javascript

query predicate test_ModuleImportNode_getAConstructorInvocation(
  DataFlow::ModuleImportNode m, DataFlow::NewNode res
) {
  res = m.getAConstructorInvocation(_)
}
