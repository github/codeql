import python

predicate is_import_time(Stmt s) { not s.getScope+() instanceof Function }

ModuleValue module_imported_by(ModuleValue m) {
  exists(Stmt imp |
    result = stmt_imports(imp) and
    imp.getEnclosingModule() = m.getScope() and
    // Import must reach exit to be part of a cycle
    imp.getAnEntryNode().getBasicBlock().reachesExit()
  )
}

/** Is there a circular import of 'm1' beginning with 'm2'? */
predicate circular_import(ModuleValue m1, ModuleValue m2) {
  m1 != m2 and
  m2 = module_imported_by(m1) and
  m1 = module_imported_by+(m2)
}

ModuleValue stmt_imports(ImportingStmt s) {
  exists(string name | result.importedAs(name) and not name = "__main__" |
    name = s.getAnImportedModuleName() and
    s.getASubExpression().pointsTo(result) and
    not result.isPackage()
  )
}

predicate import_time_imported_module(ModuleValue m1, ModuleValue m2, Stmt imp) {
  imp.getEnclosingModule() = m1.getScope() and
  is_import_time(imp) and
  m2 = stmt_imports(imp)
}

/** Is there a cyclic import of 'm1' beginning with an import 'm2' at 'imp' where all the imports are top-level? */
predicate import_time_circular_import(ModuleValue m1, ModuleValue m2, Stmt imp) {
  m1 != m2 and
  import_time_imported_module(m1, m2, imp) and
  import_time_transitive_import(m2, _, m1)
}

predicate import_time_transitive_import(ModuleValue base, Stmt imp, ModuleValue last) {
  last != base and
  (
    import_time_imported_module(base, last, imp)
    or
    exists(ModuleValue mid |
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
predicate import_time_module_use(ModuleValue m, ModuleValue enclosing, Expr use, string attr) {
  exists(Expr mod |
    use.getEnclosingModule() = enclosing.getScope() and
    not use.getScope+() instanceof Function and
    mod.pointsTo(m) and
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
    i.getModule().pointsTo().getName() = "__future__" and i.getName() = "annotations"
  ) and
  is_used_in_annotation(use)
}

/**
 * Whether importing module 'first' before importing module 'other' will fail at runtime, due to an
 * AttributeError at 'use' (in module 'other') caused by 'first.attr' not being defined as its definition can
 * occur after the import 'other' in 'first'.
 */
predicate failing_import_due_to_cycle(
  ModuleValue first, ModuleValue other, Stmt imp, ControlFlowNode defn, Expr use, string attr
) {
  import_time_imported_module(other, first, _) and
  import_time_transitive_import(first, imp, other) and
  import_time_module_use(first, other, use, attr) and
  exists(ImportTimeScope n, SsaVariable v |
    defn = v.getDefinition() and
    n = first.getScope() and
    v.getVariable().getScope() = n and
    v.getId() = attr
  |
    not defn.strictlyDominates(imp.getAnEntryNode())
  ) and
  not exists(If i | i.isNameEqMain() and i.contains(use))
}
