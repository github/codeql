/**
 * Provides the implementation of the query 'Nested loops with same variable'.
 */

import cpp

/**
 * An access to a field of the form `object.field`.
 */
predicate simpleFieldAccess(Variable object, Variable field, VariableAccess access) {
  access.getTarget() = field and
  access.getQualifier().(VariableAccess).getTarget() = object
}

/**
 * Holds if `inner` and `outer` are nested for statements that
 * use the same loop variable `iteration`.
 */
predicate nestedForViolation(ForStmt inner, Variable iteration, ForStmt outer) {
  // same variable
  iteration = inner.getAnIterationVariable() and
  iteration = outer.getAnIterationVariable() and
  // field accesses must have the same object
  (
    iteration instanceof Field
    implies
    exists(Variable obj |
      simpleFieldAccess(obj, iteration, inner.getCondition().getAChild*()) and
      simpleFieldAccess(obj, iteration, outer.getCondition().getAChild*())
    )
  ) and
  // ordinary nested loops
  exists(inner.getInitialization()) and
  inner.getParent+() = outer and
  inner.getASuccessor+() = outer.getCondition()
}
