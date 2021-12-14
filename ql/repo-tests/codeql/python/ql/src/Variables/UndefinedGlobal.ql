/**
 * @name Use of an undefined global variable
 * @description Using a global variable before it is initialized causes an exception.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision low
 * @id py/undefined-global-variable
 */

import python
import Variables.MonkeyPatched
import Loop
import semmle.python.pointsto.PointsTo

predicate guarded_against_name_error(Name u) {
  exists(Try t | t.getBody().getAnItem().contains(u) |
    t.getAHandler().getType().(Name).getId() = "NameError"
  )
  or
  exists(ConditionBlock guard, BasicBlock controlled, Call globals |
    guard.getLastNode().getNode().contains(globals) or
    guard.getLastNode().getNode() = globals
  |
    globals.getFunc().(Name).getId() = "globals" and
    guard.controls(controlled, _) and
    controlled.contains(u.getAFlowNode())
  )
}

predicate contains_unknown_import_star(Module m) {
  exists(ImportStar imp | imp.getScope() = m |
    exists(ModuleValue imported | imported.importedAs(imp.getImportedModuleName()) |
      not imported.hasCompleteExportInfo()
    )
  )
}

predicate undefined_use_in_function(Name u) {
  exists(Function f |
    u.getScope().getScope*() = f and
    // Either function is a method or inner function or it is live at the end of the module scope
    (
      not f.getScope() = u.getEnclosingModule() or
      u.getEnclosingModule().(ImportTimeScope).definesName(f.getName())
    ) and
    // There is a use, but not a definition of this global variable in the function or enclosing scope
    exists(GlobalVariable v | u.uses(v) |
      not exists(Assign a, Scope defnScope |
        a.getATarget() = v.getAnAccess() and a.getScope() = defnScope
      |
        defnScope = f
        or
        // Exclude modules as that case is handled more precisely below.
        defnScope = f.getScope().getScope*() and not defnScope instanceof Module
      )
    )
  ) and
  not u.getEnclosingModule().(ImportTimeScope).definesName(u.getId()) and
  not exists(ModuleValue m | m.getScope() = u.getEnclosingModule() | m.hasAttribute(u.getId())) and
  not globallyDefinedName(u.getId()) and
  not exists(SsaVariable var | var.getAUse().getNode() = u and not var.maybeUndefined()) and
  not guarded_against_name_error(u) and
  not (u.getEnclosingModule().isPackageInit() and u.getId() = "__path__")
}

predicate undefined_use_in_class_or_module(Name u) {
  exists(GlobalVariable v | u.uses(v)) and
  not exists(Function f | u.getScope().getScope*() = f) and
  exists(SsaVariable var | var.getAUse().getNode() = u | var.maybeUndefined()) and
  not guarded_against_name_error(u) and
  not exists(ModuleValue m | m.getScope() = u.getEnclosingModule() | m.hasAttribute(u.getId())) and
  not (u.getEnclosingModule().isPackageInit() and u.getId() = "__path__") and
  not globallyDefinedName(u.getId())
}

predicate use_of_exec(Module m) {
  exists(Exec exec | exec.getScope() = m)
  or
  exists(CallNode call, FunctionValue exec | exec.getACall() = call and call.getScope() = m |
    exec = Value::named("exec") or
    exec = Value::named("execfile")
  )
}

predicate undefined_use(Name u) {
  (
    undefined_use_in_class_or_module(u)
    or
    undefined_use_in_function(u)
  ) and
  not monkey_patched_builtin(u.getId()) and
  not contains_unknown_import_star(u.getEnclosingModule()) and
  not use_of_exec(u.getEnclosingModule()) and
  not exists(u.getVariable().getAStore()) and
  not u.pointsTo(_) and
  not probably_defined_in_loop(u)
}

private predicate first_use_in_a_block(Name use) {
  exists(GlobalVariable v, BasicBlock b, int i |
    i = min(int j | b.getNode(j).getNode() = v.getALoad()) and b.getNode(i) = use.getAFlowNode()
  )
}

predicate first_undefined_use(Name use) {
  undefined_use(use) and
  exists(GlobalVariable v | v.getALoad() = use |
    first_use_in_a_block(use) and
    not exists(ControlFlowNode other |
      other.getNode() = v.getALoad() and
      other.getBasicBlock().strictlyDominates(use.getAFlowNode().getBasicBlock())
    )
  )
}

from Name u
where first_undefined_use(u)
select u, "This use of global variable '" + u.getId() + "' may be undefined."
