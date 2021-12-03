import python

private predicate is_normal_module(ModuleObject m) {
  m instanceof BuiltinModuleObject
  or
  m instanceof PackageObject
  or
  exists(ImportingStmt i | m.importedAs(i.getAnImportedModuleName()))
  or
  m.getName().matches("%\\_\\_init\\_\\_")
}

private predicate is_script(ModuleObject m) {
  not is_normal_module(m) and
  (
    m.getModule().getFile().getExtension() != ".py"
    or
    exists(If i, Name name, StrConst main, Cmpop op |
      i.getScope() = m.getModule() and
      op instanceof Eq and
      i.getTest().(Compare).compares(name, op, main) and
      name.getId() = "__name__" and
      main.getText() = "__main__"
    )
  )
}

private predicate is_plugin(ModuleObject m) {
  // This needs refining but is sufficient for our present needs.
  not is_normal_module(m) and
  not is_script(m)
}

/**
 * Gets the kind for module `m` will be one of
 * "module", "script" or "plugin"
 */
string getKindForModule(ModuleObject m) {
  is_normal_module(m) and result = "module"
  or
  is_script(m) and result = "script"
  or
  is_plugin(m) and result = "plugin"
}
