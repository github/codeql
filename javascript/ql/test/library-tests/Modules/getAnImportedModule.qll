import javascript

query predicate test_getAnImportedModule(string res0, string res1) {
  exists(Module mod |
    res0 = mod.getFile().getRelativePath() and
    res1 = mod.getAnImportedModule().getFile().getRelativePath()
  )
}
