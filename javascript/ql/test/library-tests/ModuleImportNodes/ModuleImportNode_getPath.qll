import javascript

query predicate test_ModuleImportNode_getPath(DataFlow::ModuleImportNode m, string res) {
  res = m.getPath()
}
