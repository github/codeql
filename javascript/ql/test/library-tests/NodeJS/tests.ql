import javascript

query predicate module_getAnExportedSymbol(NodeModule m, string symbol) {
  symbol = m.getAnExportedSymbol()
}

query predicate module_getAnImport(NodeModule m, Import imp) { imp = m.getAnImport() }

query predicate module_getAnImportedModule(NodeModule m, Module mod) {
  mod = m.getAnImportedModule()
}

query predicate moduleAccess(ModuleAccess ma) { any() }

query predicate modules(NodeModule m, File file, string path, string name) {
  file = m.getFile() and
  path = m.getPath() and
  name = m.getName()
}

query predicate nodeModule_exports(Module m, string name, DataFlow::Node exportValue) {
  exportValue = m.getAnExportedValue(name)
}

query predicate require(Require r) { any() }

query predicate requireImport(Require r, string path, Module mod) {
  exists(string fullpath, string prefix |
    fullpath = r.getImportedPath().getValue() and
    sourceLocationPrefix(prefix) and
    path = fullpath.replaceAll(prefix, "") and
    mod = r.getImportedModule()
  )
}
