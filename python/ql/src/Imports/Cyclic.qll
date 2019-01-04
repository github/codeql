import python

predicate is_import_time(Stmt s) {
	not s.getScope+() instanceof Function
}

PythonModuleObject module_imported_by(PythonModuleObject m) {
    exists(Stmt imp |
        result = stmt_imports(imp) and
        imp.getEnclosingModule() = m.getModule() and
        // Import must reach exit to be part of a cycle
        imp.getAnEntryNode().getBasicBlock().reachesExit()
    )
}

/** Is there a circular import of 'm1' beginning with 'm2'? */
predicate circular_import(PythonModuleObject m1, PythonModuleObject m2) {
    m1 != m2 and
    m2 = module_imported_by(m1) and m1 = module_imported_by+(m2)
}

ModuleObject stmt_imports(ImportingStmt s) {
    exists(string name |
        result.importedAs(name) and not name = "__main__" |
        name = s.getAnImportedModuleName()
    )
}

predicate import_time_imported_module(PythonModuleObject m1, PythonModuleObject m2, Stmt imp) {
    imp.getEnclosingModule() = m1.getModule() and 
    is_import_time(imp) and
    m2 = stmt_imports(imp)
}

/** Is there a cyclic import of 'm1' beginning with an import 'm2' at 'imp' where all the imports are top-level? */
predicate import_time_circular_import(PythonModuleObject m1, PythonModuleObject m2, Stmt imp) {
    m1 != m2 and
    import_time_imported_module(m1, m2, imp) and 
    import_time_transitive_import(m2, _, m1)
}

predicate import_time_transitive_import(PythonModuleObject base, Stmt imp, PythonModuleObject last) {
    last != base and
    (
        import_time_imported_module(base, last, imp)
        or
        exists(PythonModuleObject mid | 
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
predicate import_time_module_use(PythonModuleObject m, PythonModuleObject enclosing, Expr use, string attr) {
    exists(Expr mod | 
        use.getEnclosingModule() = enclosing.getModule() and
        not use.getScope+() instanceof Function
        and mod.refersTo(m)
        |
        // either 'M.foo'
        use.(Attribute).getObject() = mod and use.(Attribute).getName() = attr
        or
        // or 'from M import foo'
        use.(ImportMember).getModule() = mod and use.(ImportMember).getName() = attr
    )
}

/** Whether importing module 'first' before importing module 'other' will fail at runtime, due to an
    AttributeError at 'use' (in module 'other') caused by 'first.attr' not being defined as its definition can
    occur after the import 'other' in 'first'.
*/
predicate failing_import_due_to_cycle(PythonModuleObject first, PythonModuleObject other, Stmt imp,
                                      ControlFlowNode defn, Expr use, string attr) {
    import_time_imported_module(other, first, _) and
    import_time_transitive_import(first, imp, other) and
    import_time_module_use(first, other, use, attr) and
    exists(ImportTimeScope n, SsaVariable v | 
        defn = v.getDefinition() and
        n = first.getModule() and v.getVariable().getScope() = n and v.getId() = attr |
        not defn.strictlyDominates(imp.getAnEntryNode())
    )
    and not exists(If i | i.isNameEqMain() and i.contains(use))
}

