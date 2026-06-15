/**
 * @name Variable not initialized before use
 * @description Using an uninitialized variable may lead to undefined results.
 * @kind problem
 * @id cpp/not-initialised
 * @problem.severity error
 * @tags reliability
 *       external/cwe/cwe-457
 */

/*
 * See also InitialisationNotRun.ql and GlobalUseBeforeInit.ql
 */

import cpp

/**
 * Holds if `s` defines variable `v` (conservative).
 */
predicate defines(ControlFlowNode s, Variable lv) {
  exists(VariableAccess va | va = s and va.getTarget() = lv and va.isUsedAsLValue())
}

/**
 * Holds if `s` uses variable `v` (conservative).
 */
predicate uses(ControlFlowNode s, Variable lv) {
  exists(VariableAccess va |
    va = s and
    va.getTarget() = lv and
    va.isRValue() and
    not va.getParent+() instanceof SizeofOperator
  )
}

/**
 * Holds if there is a path from the declaration of `lv` to `n` such that `lv` is
 * definitely not defined before `n`.
 */
predicate noDefPath(LocalVariable lv, ControlFlowNode n) {
  n.(DeclStmt).getADeclaration() = lv and not exists(lv.getInitializer())
  or
  exists(ControlFlowNode p | noDefPath(lv, p) and n = p.getASuccessor() and not defines(p, lv))
}

predicate isAggregateType(Type t) { t instanceof Class or t instanceof ArrayType }

/**
 * Holds if `va` is a use of a local variable that has not been previously
 * defined.
 */
predicate undefinedLocalUse(VariableAccess va) {
  exists(LocalVariable lv |
    // it is hard to tell when a struct or array has been initialized, so we
    // ignore them
    not isAggregateType(lv.getUnderlyingType()) and
    not lv.isStatic() and // static variables are initialized to zero or null by default
    not lv.getType().hasName("va_list") and
    va = lv.getAnAccess() and
    noDefPath(lv, va) and
    uses(va, lv)
  )
}

/**
 * Holds if `gv` is a potentially uninitialized global variable.
 */
predicate uninitialisedGlobal(GlobalVariable gv) {
  exists(VariableAccess va |
    not isAggregateType(gv.getUnderlyingType()) and
    va = gv.getAnAccess() and
    va.isRValue() and
    not gv.hasInitializer() and
    not gv.hasSpecifier("extern") and
    not gv.isStatic() // static variables are initialized to zero or null by default
  )
}

from Element elt
where undefinedLocalUse(elt) or uninitialisedGlobal(elt)
select elt, "Variable '" + elt.toString() + "' is not initialized."
