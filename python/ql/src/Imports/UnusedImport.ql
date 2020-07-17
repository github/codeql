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

predicate global_name_used(Module m, string name) {
  exists(Name u, GlobalVariable v |
    u.uses(v) and
    v.getId() = name and
    u.getEnclosingModule() = m
  )
  or
  // A use of an undefined class local variable, will use the global variable
  exists(Name u, LocalVariable v |
    u.uses(v) and
    v.getId() = name and
    u.getEnclosingModule() = m and
    not v.getScope().getEnclosingScope*() instanceof Function
  )
}

/** Holds if a module has `__all__` but we don't understand it */
predicate all_not_understood(Module m) {
  exists(GlobalVariable a | a.getId() = "__all__" and a.getScope() = m |
    // `__all__` is not defined as a simple list
    not m.declaredInAll(_)
    or
    // `__all__` is modified
    exists(Call c | c.getFunc().(Attribute).getObject() = a.getALoad())
  )
}

predicate imported_module_used_in_doctest(Import imp) {
  exists(string modname, string docstring |
    imp.getAName().getAsname().(Name).getId() = modname and
    // Look for doctests containing the patterns:
    // >>> …name…
    // ... …name…
    docstring = doctest_in_scope(imp.getScope()) and
    docstring.regexpMatch("[\\s\\S]*(>>>|\\.\\.\\.).*" + modname + "[\\s\\S]*")
  )
}

pragma[noinline]
private string doctest_in_scope(Scope scope) {
  exists(StrConst doc |
    doc.getEnclosingModule() = scope and
    doc.isDocString() and
    result = doc.getText() and
    result.regexpMatch("[\\s\\S]*(>>>|\\.\\.\\.)[\\s\\S]*")
  )
}

pragma[noinline]
private string typehint_annotation_in_module(Module module_scope) {
  exists(StrConst annotation |
    annotation = any(Arguments a).getAnAnnotation().getASubExpression*()
    or
    annotation = any(AnnAssign a).getAnnotation().getASubExpression*()
    or
    annotation = any(FunctionExpr f).getReturns().getASubExpression*()
  |
    annotation.pointsTo(Value::forString(result)) and
    annotation.getEnclosingModule() = module_scope
  )
}

pragma[noinline]
private string typehint_comment_in_file(File file) {
  exists(Comment typehint |
    file = typehint.getLocation().getFile() and
    result = typehint.getText() and
    result.matches("# type:%")
  )
}

/** Holds if the imported alias `name` from `imp` is used in a typehint (in the same file as `imp`) */
predicate imported_alias_used_in_typehint(Import imp, Variable name) {
  imp.getAName().getAsname().(Name).getVariable() = name and
  exists(File file, Module module_scope |
    module_scope = imp.getEnclosingModule() and
    file = module_scope.getFile()
  |
    // Look for type hints containing the patterns:
    // # type: …name…
    typehint_comment_in_file(file).regexpMatch("# type:.*" + name.getId() + ".*")
    or
    // Type hint is inside a string annotation, as needed for forward references
    typehint_annotation_in_module(module_scope).regexpMatch(".*\\b" + name.getId() + "\\b.*")
  )
}

predicate unused_import(Import imp, Variable name) {
  imp.getAName().getAsname().(Name).getVariable() = name and
  not imp.getAnImportedModuleName() = "__future__" and
  not imp.getEnclosingModule().declaredInAll(name.getId()) and
  imp.getScope() = imp.getEnclosingModule() and
  not global_name_used(imp.getScope(), name.getId()) and
  // Imports in `__init__.py` are used to force module loading
  not imp.getEnclosingModule().isPackageInit() and
  // Name may be imported for use in epytext documentation
  not exists(Comment cmt | cmt.getText().matches("%L{" + name.getId() + "}%") |
    cmt.getLocation().getFile() = imp.getLocation().getFile()
  ) and
  not name_acceptable_for_unused_variable(name) and
  // Assume that opaque `__all__` includes imported module
  not all_not_understood(imp.getEnclosingModule()) and
  not imported_module_used_in_doctest(imp) and
  not imported_alias_used_in_typehint(imp, name) and
  // Only consider import statements that actually point-to something (possibly an unknown module).
  // If this is not the case, it's likely that the import statement never gets executed.
  imp.getAName().getValue().pointsTo(_)
}

from Stmt s, Variable name
where unused_import(s, name)
select s, "Import of '" + name.getId() + "' is not used."
