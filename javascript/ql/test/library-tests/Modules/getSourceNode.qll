import javascript

query predicate test_getSourceNode(ExportDeclaration ed, string name, DataFlow::Node res) {
  res = ed.getSourceNode(name)
}
