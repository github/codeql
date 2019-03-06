import javascript

query predicate test_ModuleImportNode_getAPropertyRead(
  DataFlow::ModuleImportNode m, DataFlow::PropRead res
) {
  res = m.getAPropertyRead(_)
}
