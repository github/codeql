/**
 * @name String concatenation in loop
 * @description Finds code that performs string concatenation in a loop using the + operator.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cs/string-concatenation-in-loop
 * @tags efficiency
 *       maintainability
 */

import csharp

// any use of + that has string type
class StringCat extends AddExpr {
  StringCat() { this.getType() instanceof StringType }
}

/**
 * Holds if `e` is an assignment of the form
 * `v = ... + ... v ...`
 * where `v` is a simple variable (and not, for example, a property).
 */
predicate isSelfConcatAssignExpr(AssignExpr e, Variable v) {
  not e = any(AssignAddExpr a).getExpandedAssignment() and
  exists(VariableAccess use |
    stringCatContains(e.getRValue(), use) and
    use.getTarget() = e.getTargetVariable() and
    v = use.getTarget()
  )
}

predicate stringCatContains(StringCat expr, Expr child) {
  child = expr or
  stringCatContains(expr, child.getParent())
}

/**
 * Holds if `e` is an assignment of the form
 * `v += ...`
 * where `v` is a simple variable (and not, for example, a property).
 */
predicate isConcatExpr(AssignAddExpr e, Variable v) {
  e.getLValue().getType() instanceof StringType and
  v = e.getTargetVariable()
}

from Expr e
where
  exists(LoopStmt loop, Variable v |
    e.getEnclosingStmt().getParent*() = loop and
    (isSelfConcatAssignExpr(e, v) or isConcatExpr(e, v)) and
    forall(LocalVariableDeclExpr l | l.getVariable() = v | not l.getParent*() = loop)
  )
select e, "String concatenation in loop: use 'StringBuilder'."
