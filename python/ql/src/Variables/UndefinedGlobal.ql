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
private import semmle.python.dataflow.new.internal.ImportResolution
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.ApiGraphs
private import semmle.python.types.ImportTime
import Loop

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
  exists(ImportStar imp, Module imported |
    imp.getScope() = m and
    ImportResolution::getModuleImportedByImportStar(imp) = imported
  |
    // The imported module dynamically creates attributes, so we can't
    // enumerate its exports.
    exists(Function f | f.getName() = "__getattr__" and f.getScope() = imported)
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
  not ImportResolution::module_export(u.getEnclosingModule(), u.getId(), _) and
  not DuckTyping::globallyDefinedName(u.getId()) and
  not Reachability::maybeUndefined(u) and
  not guarded_against_name_error(u) and
  not (u.getEnclosingModule().isPackageInit() and u.getId() = "__path__")
}

predicate undefined_use_in_class_or_module(Name u) {
  exists(GlobalVariable v | u.uses(v)) and
  not u.getScope().getScope*() instanceof Function and
  Reachability::maybeUndefined(u) and
  not guarded_against_name_error(u) and
  not u.getEnclosingModule().(ImportTimeScope).definesName(u.getId()) and
  not ImportResolution::module_export(u.getEnclosingModule(), u.getId(), _) and
  not (u.getEnclosingModule().isPackageInit() and u.getId() = "__path__") and
  not DuckTyping::globallyDefinedName(u.getId())
}

predicate use_of_exec(Module m) {
  exists(Exec exec | exec.getScope() = m)
  or
  API::builtin(["exec", "execfile"]).getACall().getScope() = m
}

predicate undefined_use(Name u) {
  (
    undefined_use_in_class_or_module(u)
    or
    undefined_use_in_function(u)
  ) and
  not DuckTyping::monkeyPatchedBuiltin(u.getId()) and
  not contains_unknown_import_star(u.getEnclosingModule()) and
  not use_of_exec(u.getEnclosingModule()) and
  not exists(u.getVariable().getAStore()) and
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
