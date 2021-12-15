import javascript

query predicate test_ModuleImportNode_getAMemberInvocation(
  DataFlow::ModuleImportNode m, DataFlow::InvokeNode res
) {
  res = m.getAMemberInvocation(_)
}
