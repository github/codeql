/**
 * @name Unused import
 * @description Import is not required as it is not used
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/unused-import
 */

import python
import Variables.Definition

predicate global_name_used(Module m, Variable name) {
    exists (Name u, GlobalVariable v |
        u.uses(v) and
        v.getId() = name.getId() and
        u.getEnclosingModule() = m
    )
    or
    /* A use of an undefined class local variable, will use the global variable */
    exists(Name u, LocalVariable v |
        u.uses(v) and
        v.getId() = name.getId() and
        u.getEnclosingModule() = m and
        not v.getScope().getEnclosingScope*() instanceof Function
    )
}

/** Holds if a module has `__all__` but we don't understand it */
predicate all_not_understood(Module m) {
    exists(GlobalVariable a | 
        a.getId() = "__all__" and a.getScope() = m |
        /* __all__ is not defined as a simple list */
        not m.declaredInAll(_)
        or
        /* __all__ is modified */
        exists(Call c | c.getFunc().(Attribute).getObject() = a.getALoad())
    )
}

predicate unused_import(Import imp, Variable name) {
    ((Name)imp.getAName().getAsname()).getVariable() = name
    and
    not imp.getAnImportedModuleName() = "__future__"
    and
    not imp.getEnclosingModule().declaredInAll(name.getId())
    and
    imp.getScope() = imp.getEnclosingModule()
    and
    not global_name_used(imp.getScope(), name)
    and
    /* Imports in __init__.py are used to force module loading */
    not imp.getEnclosingModule().isPackageInit()
    and
    /* Name may be imported for use in epytext documentation */
    not exists(Comment cmt |
        cmt.getText().matches("%L{" + name.getId() + "}%") |
        cmt.getLocation().getFile() = imp.getLocation().getFile()
    )
    and
    not name_acceptable_for_unused_variable(name)
    and
    /* Assume that opaque `__all__` includes imported module */
    not all_not_understood(imp.getEnclosingModule())
}


from Stmt s, Variable name
where unused_import(s, name)
select s, "Import of '" + name.getId() + "' is not used."

