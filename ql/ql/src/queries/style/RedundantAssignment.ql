/**
 * @name Redundant assignment.
 * @description Assigning the same value twice is redundant.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id ql/redunant-assignment
 * @tags maintainability
 */

import ql
import codeql_ql.style.ConjunctionParent
import codeql.GlobalValueNumbering as GVN

/**
 * A variable that is set equal to (assigned) a value one or more times.
 */
class AssignedVariable extends VarDecl {
  AssignedVariable() {
    exists(VarAccess access, ComparisonFormula comp | comp.getOperator() = "=" |
      access.getDeclaration() = this and
      comp.getAnOperand() = access
    )
  }

  /**
   * Gets an expression that is assigned to this variable.
   */
  Expr getAnAssignedExpr() {
    exists(VarAccess access, ComparisonFormula comp, Expr operand |
      comp.getOperator() = "=" and
      access.getDeclaration() = this and
      comp.getAnOperand() = access and
      operand = comp.getAnOperand() and
      not operand.(VarAccess).getDeclaration() = this
    |
      result = operand and
      not result instanceof Set
      or
      result = operand.(Set).getAnElement()
    )
  }
}

/**
 * Holds if `assigned1` and `assigned2` assigns the same value to `var`.
 * The assignments may be on different branches of a disjunction.
 */
predicate candidateRedundantAssignment(AssignedVariable var, Expr assigned1, Expr assigned2) {
  assigned1 = var.getAnAssignedExpr() and
  assigned2 = var.getAnAssignedExpr() and
  (
    GVN::valueNumber(assigned1) = GVN::valueNumber(assigned2)
    or
    // because GVN skips large strings, we need to check for equality manually
    assigned1.(String).getValue() = assigned2.(String).getValue()
  ) and
  assigned1 != assigned2
}

/** Holds if `p` is a candidate node for redundant assignment. */
predicate candidateNode(AstNode p) { candidateRedundantAssignment(_, p, _) }

from AssignedVariable var, Expr assigned1, Expr assigned2
where
  candidateRedundantAssignment(var, assigned1, assigned2) and
  ConjunctionParent<candidateNode/1>::getConjunctionParent(assigned1) =
    ConjunctionParent<candidateNode/1>::getConjunctionParent(assigned2) and
  // de-duplcation:
  (
    assigned1.getLocation().getStartLine() < assigned2.getLocation().getStartLine()
    or
    assigned1.getLocation().getStartLine() = assigned2.getLocation().getStartLine() and
    assigned1.getLocation().getStartColumn() < assigned2.getLocation().getStartColumn()
  )
select assigned2, "$@ has previously been assigned $@.", var, "The variable " + var.getName(),
  assigned1, "the same value"
