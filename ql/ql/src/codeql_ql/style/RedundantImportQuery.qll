import ql
private import YAML
private import codeql_ql.ast.internal.Module

private FileOrModule getResolvedModule(Import imp) {
  result = imp.getResolvedModule() and
  // skip the top-level language files
  not result.asFile() = any(QLPack p).getLanguageLib()
}

private Import imports(Import imp) {
  (
    exists(File file, TopLevel top |
      getResolvedModule(imp).asFile() = file and
      top.getLocation().getFile() = file and
      result = top.getAMember()
    )
    or
    exists(Module mod |
      getResolvedModule(imp).asModule() = mod and
      result = mod.getAMember()
    )
  )
}

private Import getAnImport(AstNode parent) {
  result = parent.(TopLevel).getAMember()
  or
  result = parent.(Module).getAMember()
}

predicate problem(Import imp, Import redundant, string message) {
  not exists(imp.importedAs()) and
  not exists(redundant.importedAs()) and
  not exists(imp.getModuleExpr().getQualifier*().getArgument(_)) and // any type-arguments, and we ignore, they might be different.
  // skip the top-level language files, they have redundant imports, and that's fine.
  not imp.getLocation().getFile() = any(QLPack p).getLanguageLib() and
  // skip the DataFlowImpl.qll and similar, they have redundant imports in some copies.
  not imp.getLocation()
      .getFile()
      .getBaseName()
      .regexpMatch([".*Impl\\d?\\.qll", "DataFlowImpl.*\\.qll"]) and
  // if the redundant is public, and the imp is private, then the redundant might add things that are exported.
  not (imp.isPrivate() and not redundant.isPrivate()) and
  // Actually checking if the import is redundant:
  exists(AstNode parent |
    imp = getAnImport(parent) and
    redundant = getAnImport(parent)
  |
    message = "Redundant import, the module is already imported inside $@." and
    // only looking for things directly imported one level down. Otherwise things gets complicated (lots of cycles).
    exists(Import inner | inner = imports(imp) |
      getResolvedModule(redundant) = getResolvedModule(inner) and
      not inner.isPrivate() and // if the inner is private, then it's not propagated out.
      not inner.isDeprecated() and
      not exists(inner.importedAs())
    )
    or
    message = "Duplicate import, the module is already imported by $@." and
    // two different import statements, that import the same thing
    getResolvedModule(imp) = getResolvedModule(redundant) and
    redundant.getLocation().getStartLine() > imp.getLocation().getStartLine()
  )
}
