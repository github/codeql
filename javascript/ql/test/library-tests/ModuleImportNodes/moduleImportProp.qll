import javascript

query predicate test_moduleImportProp(string path, string prop, DataFlow::PropRead res) {
  res = DataFlow::moduleImport(path).getAPropertyRead(prop)
}
