import javascript

query predicate test_ModuleImportNode_getAMemberCall(
  DataFlow::ModuleImportNode m, DataFlow::CallNode res
) {
  res = m.getAMemberCall(_)
}
