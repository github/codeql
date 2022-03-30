import javascript

query predicate test_moduleImport(string path, DataFlow::ModuleImportNode res) {
  res = DataFlow::moduleImport(path)
}
