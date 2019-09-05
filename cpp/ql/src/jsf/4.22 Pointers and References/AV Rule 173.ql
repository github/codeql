/**
 * @name AV Rule 173
 * @description The address of an object with automatic storage shall not be
 *              assigned to an object which persists after the object has ceased
 *              to exist.
 * @kind problem
 * @id cpp/jsf/av-rule-173
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * see MISRA Rule 7-5-2
 * TODO: this catches only the most obvious cases
 *
 * Current caught cases: assignment x = &y (literally) where
 *   - y is a local
 *   - EITHER x is a nonlocal
 *   - OR x is a local defined in an enclosing scope
 *   - OR x has static storage duration
 */

from Assignment a, Variable global, Variable local
where
  a.fromSource() and
  global.getAnAccess() = a.getLValue().(VariableAccess) and
  local.getAnAccess() = a.getRValue().(AddressOfExpr).getOperand() and
  local.hasSpecifier("auto") and
  (
    not global instanceof LocalVariable or
    global.getParentScope() = local.getParentScope().getParentScope+() or
    global.hasSpecifier("static")
  )
select a,
  "AV Rule 173: The address of an object with automatic storage shall not be assigned to another object that may persist after the first object has ceased to exist"
