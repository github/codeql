import python
private import semmle.python.dataflow.new.internal.ImportResolution
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.types.ImportTime

Module module_imported_by(Module m) {
  exists(ImportingStmt imp |
    result = stmt_imports(imp) and
    imp.getEnclosingModule() = m and
    // Import must reach exit to be part of a cycle
    imp.getAnEntryNode().getBasicBlock().reachesExit()
  )
}

/** Is there a circular import of 'm1' beginning with 'm2'? */
predicate circular_import(Module m1, Module m2) {
  m1 != m2 and
  m2 = module_imported_by(m1) and
  m1 = module_imported_by+(m2)
}

Module stmt_imports(ImportingStmt s) {
  (
    // `import m` — the alias target refers to the imported module
    exists(Alias a | a = s.(Import).getAName() |
      ImportResolution::getImmediateModuleReference(result).asExpr() = a.getAsname()
    )
    or
    // `from m import x` — the source module `m` is also imported,
    // but only if the imported member `x` is not a submodule of `m`
    exists(ImportMember im | im = s.(Import).getAName().getValue() |
      ImportResolution::getImmediateModuleReference(result).asExpr() = im.getModule() and
      not ImportResolution::getImmediateModuleReference(_).asExpr() = im
    )
    or
    // `from m import *`
    ImportResolution::getImmediateModuleReference(result).asExpr() =
      s.(ImportStar).getModule().(ImportExpr)
  ) and
  not result.isPackage() and
  not result.isPackageInit() and
  Reachability::likelyReachable(s.getAnEntryNode().getBasicBlock())
}

predicate import_time_imported_module(Module m1, Module m2, Stmt imp) {
  imp.(ImportingStmt).getEnclosingModule() = m1 and
  imp.getScope() instanceof ImportTimeScope and
  m2 = stmt_imports(imp)
}

/** Is there a cyclic import of 'm1' beginning with an import 'm2' at 'imp' where all the imports are top-level? */
predicate import_time_circular_import(Module m1, Module m2, Stmt imp) {
  m1 != m2 and
  import_time_imported_module(m1, m2, imp) and
  import_time_transitive_import(m2, _, m1)
}

predicate import_time_transitive_import(Module base, Stmt imp, Module last) {
  last != base and
  (
    import_time_imported_module(base, last, imp)
    or
    exists(Module mid |
      import_time_transitive_import(base, imp, mid) and
      import_time_imported_module(mid, last, _)
    )
  ) and
  // Import must reach exit to be part of a cycle
  imp.getAnEntryNode().getBasicBlock().reachesExit()
}

/**
 * Returns import-time usages of module 'm' in module 'enclosing'
 */
predicate import_time_module_use(Module m, Module enclosing, Expr use, string attr) {
  exists(Expr mod |
    use.getEnclosingModule() = enclosing and
    use.getScope() instanceof ImportTimeScope and
    ImportResolution::getModuleReference(m).asExpr() = mod and
    not is_annotation_with_from_future_import_annotations(use)
  |
    // either 'M.foo'
    use.(Attribute).getObject() = mod and use.(Attribute).getName() = attr
    or
    // or 'from M import foo'
    use.(ImportMember).getModule() = mod and use.(ImportMember).getName() = attr
  )
}

/**
 * Holds if `use` appears inside an annotation.
 */
predicate is_used_in_annotation(Expr use) {
  exists(FunctionExpr f |
    f.getReturns().getASubExpression*() = use or
    f.getArgs().getAnAnnotation().getASubExpression*() = use
  )
  or
  exists(AnnAssign a | a.getAnnotation().getASubExpression*() = use)
}

/**
 * Holds if `use` appears as a subexpression of an annotation, _and_ if the
 * postponed evaluation of annotations presented in PEP 563 is in effect.
 * See https://www.python.org/dev/peps/pep-0563/
 */
predicate is_annotation_with_from_future_import_annotations(Expr use) {
  exists(ImportMember i | i.getScope() = use.getEnclosingModule() |
    i.getModule().(ImportExpr).getImportedModuleName() = "__future__" and
    i.getName() = "annotations"
  ) and
  is_used_in_annotation(use)
}

/**
 * Whether importing module 'first' before importing module 'other' will fail at runtime, due to an
 * AttributeError at 'use' (in module 'other') caused by 'first.attr' not being defined as its definition can
 * occur after the import 'other' in 'first'.
 */
predicate failing_import_due_to_cycle(
  Module first, Module other, Stmt imp, ControlFlowNode defn, Expr use, string attr
) {
  import_time_imported_module(other, first, _) and
  import_time_transitive_import(first, imp, other) and
  import_time_module_use(first, other, use, attr) and
  exists(ImportTimeScope n, SsaVariable v |
    defn = v.getDefinition() and
    n = first and
    v.getVariable().getScope() = n and
    v.getId() = attr
  |
    not defn.strictlyDominates(imp.getAnEntryNode())
  ) and
  not exists(If i | i.isNameEqMain() and i.contains(use))
}
