import javascript

query predicate resolveableImport(Import imp, Module mod) {
  mod = imp.getImportedModule() and
  not imp.getTopLevel().isExterns() and
  not mod.getTopLevel().isExterns()
}
