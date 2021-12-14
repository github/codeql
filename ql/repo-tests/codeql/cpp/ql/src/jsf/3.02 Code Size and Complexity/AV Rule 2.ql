/**
 * @name AV Rule 2
 * @description There shall not be any self-modifying code.
 * @kind problem
 * @id cpp/jsf/av-rule-2
 * @problem.severity error
 * @tags maintainability
 *       readability
 *       testability
 *       external/jsf
 */

import cpp

// We look for code that converts between function pointers and non-function, non-void
// pointers. This will obviously not catch code that uses inline assembly to achieve
// self-modification, nor will it spot the use of OS mechanisms to write into process
// memory (such as WriteProcessMemory under Windows).
predicate maybeSMCConversion(Type t1, Type t2) {
  t1 instanceof FunctionPointerType and
  t2 instanceof PointerType and
  not t2 instanceof FunctionPointerType and
  not t2 instanceof VoidPointerType
  or
  maybeSMCConversion(t2, t1)
}

from Expr e
where
  e.fromSource() and
  maybeSMCConversion(e.getUnderlyingType(), e.getActualType())
select e, "AV Rule 2: There shall not be any self-modifying code."
