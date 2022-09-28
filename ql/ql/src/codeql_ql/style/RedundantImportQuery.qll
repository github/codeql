import ql

Import imports(Import imp) {
  (
    exists(File file, TopLevel top |
      imp.getResolvedModule().asFile() = file and
      top.getLocation().getFile() = file and
      result = top.getAMember()
    )
    or
    exists(Module mod |
      imp.getResolvedModule().asModule() = mod and
      result = mod.getAMember()
    )
  )
}

Import getAnImport(AstNode parent) {
  result = parent.(TopLevel).getAMember()
  or
  result = parent.(Module).getAMember()
}

pragma[inline]
predicate importsFromSameFolder(Import a, Import b) {
  exists(string base |
    a.getImportString().regexpCapture("(.*)\\.[^\\.]*", 1) = base and
    b.getImportString().regexpCapture("(.*)\\.[^\\.]*", 1) = base
  )
  or
  not a.getImportString().matches("%.%") and
  not b.getImportString().matches("%.%")
}

predicate problem(Import imp, Import redundant, string message) {
  not exists(imp.importedAs()) and
  not exists(redundant.importedAs()) and
  not exists(imp.getModuleExpr().getQualifier*().getArgument(_)) and // any type-arguments, and we ignore, they might be different.
  // skip the top-level language files, they have redundant imports, and that's fine.
  not exists(imp.getLocation().getFile().getParentContainer().getFile("qlpack.yml")) and
  // skip the DataFlowImpl.qll and similar, they have redundant imports in some copies.
  not imp.getLocation()
      .getFile()
      .getBaseName()
      .regexpMatch([".*Impl\\d?\\.qll", "DataFlowImpl.*\\.qll"]) and
  // skip two imports that imports different things from the same folder.
  not importsFromSameFolder(imp, redundant) and
  // if the redundant is public, and the imp is private, then the redundant might add things that are exported.
  not (imp.isPrivate() and not redundant.isPrivate()) and
  // Actually checking if the import is redundant:
  exists(AstNode parent |
    imp = getAnImport(parent) and
    redundant = getAnImport(parent) and
    redundant.getLocation().getStartLine() > imp.getLocation().getStartLine()
  |
    message = "Redundant import, the module is already imported inside $@." and
    // only looking for things directly imported one level down. Otherwise things gets complicated (lots of cycles).
    exists(Import inner | inner = imports(imp) |
      redundant.getResolvedModule() = inner.getResolvedModule() and
      not inner.isPrivate() and // if the inner is private, then it's not propagated out.
      not exists(inner.importedAs())
    )
    or
    message = "Duplicate import, the module is already imported by $@." and
    // two different import statements, that import the same thing
    imp.getResolvedModule() = redundant.getResolvedModule()
  )
}
