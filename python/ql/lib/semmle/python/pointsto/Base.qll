/**
 * Combined points-to and type-inference for "run-time" (as opposed to "import-time" values)
 * The main relation `runtime_points_to(node, object, cls, origin)` relates a control flow node
 * to the possible objects it points-to the inferred types of those objects and the 'origin'
 * of those objects. The 'origin' is the point in source code that the object can be traced
 * back to.
 *
 * This file contains non-layered parts of the points-to analysis.
 */

import python
import semmle.python.essa.SsaDefinitions
private import semmle.python.types.Builtins
private import semmle.python.internal.CachedStages

/*
 * The following predicates exist in order to provide
 * more precise type information than the underlying
 * database relations. This help to optimise the points-to
 * analysis.
 */

/** Holds if this class (not on a super-class) declares name */
pragma[noinline]
predicate class_declares_attribute(ClassObject cls, string name) {
  exists(Class defn |
    defn = cls.getPyClass() and
    class_defines_name(defn, name)
  )
  or
  exists(Builtin o |
    o = cls.asBuiltin().getMember(name) and
    not exists(Builtin sup |
      sup = cls.asBuiltin().getBaseClass() and
      o = sup.getMember(name)
    )
  )
}

/** Holds if the class defines name */
private predicate class_defines_name(Class cls, string name) {
  exists(SsaVariable var | name = var.getId() and var.getAUse() = cls.getANormalExit())
}

/** Hold if `expr` is a test (a branch) and `use` is within that test */
predicate test_contains(ControlFlowNode expr, ControlFlowNode use) {
  expr.getNode() instanceof Expr and
  expr.isBranch() and
  expr.getAChild*() = use
}

/** Holds if `f` is an import of the form `from .[...] import ...` and the enclosing scope is an __init__ module */
predicate import_from_dot_in_init(ImportExprNode f) {
  f.getScope() = any(Module m).getInitModule() and
  (
    f.getNode().getLevel() = 1 and
    not exists(f.getNode().getName())
    or
    f.getNode().getImportedModuleName() = f.getEnclosingModule().getPackage().getName()
  )
}

/** Gets the pseudo-object representing the value referred to by an undefined variable */
Object undefinedVariable() { py_special_objects(result, "_semmle_undefined_value") }

/** Gets the pseudo-object representing an unknown value */
Object unknownValue() { result.asBuiltin() = Builtin::unknown() }

pragma[nomagic]
private predicate essa_var_scope(SsaSourceVariable var, Scope pred_scope, EssaVariable pred_var) {
  BaseFlow::reaches_exit(pred_var) and
  pred_var.getScope() = pred_scope and
  var = pred_var.getSourceVariable()
}

pragma[nomagic]
private predicate scope_entry_def_scope(
  SsaSourceVariable var, Scope succ_scope, ScopeEntryDefinition succ_def
) {
  var = succ_def.getSourceVariable() and
  succ_def.getScope() = succ_scope
}

pragma[nomagic]
private predicate step_through_init(Scope succ_scope, Scope pred_scope, Scope init) {
  init.getName() = "__init__" and
  init.precedes(succ_scope) and
  pred_scope.precedes(init)
}

pragma[nomagic]
private predicate scope_entry_value_transfer_through_init(
  EssaVariable pred_var, Scope pred_scope, ScopeEntryDefinition succ_def, Scope succ_scope
) {
  exists(SsaSourceVariable var, Scope init |
    var instanceof GlobalVariable and
    essa_var_scope(var, pragma[only_bind_into](pred_scope), pred_var) and
    scope_entry_def_scope(var, succ_scope, succ_def) and
    step_through_init(succ_scope, pragma[only_bind_into](pred_scope), init) and
    not var.(Variable).getAStore().getScope() = init
  )
}

module BaseFlow {
  predicate reaches_exit(EssaVariable var) { var.getAUse() = var.getScope().getANormalExit() }

  /* Helper for this_scope_entry_value_transfer(...). Transfer of values from earlier scope to later on */
  cached
  predicate scope_entry_value_transfer_from_earlier(
    EssaVariable pred_var, Scope pred_scope, ScopeEntryDefinition succ_def, Scope succ_scope
  ) {
    Stages::PointsTo::ref() and
    exists(SsaSourceVariable var |
      essa_var_scope(var, pred_scope, pred_var) and
      scope_entry_def_scope(var, succ_scope, succ_def)
    |
      pred_scope.precedes(succ_scope)
    )
    or
    // If an `__init__` method does not modify the global variable, then
    // we can skip it and take the value directly from the module.
    scope_entry_value_transfer_through_init(pred_var, pred_scope, succ_def, succ_scope)
  }
}
