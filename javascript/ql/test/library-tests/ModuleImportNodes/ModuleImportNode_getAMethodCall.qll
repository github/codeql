import javascript

query predicate test_ModuleImportNode_getAMethodCall(
  DataFlow::ModuleImportNode m, DataFlow::CallNode res
) {
  res = m.getAMethodCall(_)
}
