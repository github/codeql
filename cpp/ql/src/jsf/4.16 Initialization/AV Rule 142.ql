/**
 * @name AV Rule 142
 * @description All variables shall be initialized before use.
 * @kind problem
 * @id cpp/jsf/av-rule-142
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

// whether s defines variable v (conservative)
predicate defines(ControlFlowNode s, Variable lv) {
  exists(VariableAccess va | va = s and va.getTarget() = lv and va.isLValue())
}

// whether s uses variable v (conservative)
predicate uses(ControlFlowNode s, Variable lv) {
  exists(VariableAccess va |
    va = s and
    va.getTarget() = lv and
    va.isRValue() and
    not va.getParent+() instanceof SizeofOperator
  )
}

// whether there is a path from the declaration of lv to n such that lv is definitely not defined before n
predicate noDefPath(LocalVariable lv, ControlFlowNode n) {
  n.(DeclStmt).getADeclaration() = lv and not exists(lv.getInitializer())
  or
  exists(ControlFlowNode p | noDefPath(lv, p) and n = p.getASuccessor() and not defines(p, lv))
}

predicate isAggregateType(Type t) { t instanceof Class or t instanceof ArrayType }

// whether va is a use of a local variable that has not been previously defined
predicate undefinedLocalUse(VariableAccess va) {
  exists(LocalVariable lv |
    // it is hard to tell when a struct or array has been initialised, so we ignore them
    not isAggregateType(lv.getUnderlyingType()) and
    not lv.getType().hasName("va_list") and
    va = lv.getAnAccess() and
    noDefPath(lv, va) and
    uses(va, lv)
  )
}

// whether gv is a potentially uninitialised global variable
predicate uninitialisedGlobal(GlobalVariable gv) {
  exists(VariableAccess va |
    not isAggregateType(gv.getUnderlyingType()) and
    va = gv.getAnAccess() and
    va.isRValue() and
    not gv.hasInitializer() and
    not gv.hasSpecifier("extern")
  )
}

from Element elt
where undefinedLocalUse(elt) or uninitialisedGlobal(elt)
select elt, "AV Rule 142: All variables shall be initialized before use."
