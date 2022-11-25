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

import codeql.GlobalValueNumbering as GVN

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

/**
 * Gets a (transitive) parent of `p`, where the parent is not a disjunction, and `p` is a candidate assignment from `candidateRedundantAssignment`.
 */
AstNode getConjunctionParentRec(AstNode p) {
  candidateRedundantAssignment(_, p, _) and
  result = p
  or
  result = getConjunctionParentRec(p).getParent() and
  not result instanceof Disjunction and
  not result instanceof IfFormula and
  not result instanceof Implication and
  not result instanceof Negation and
  not result instanceof Predicate
}

/**
 * Gets which level in the AST `p` is at.
 * E.g. the top-level is 0, the next level is 1, etc.
 */
int level(AstNode p) {
  p instanceof TopLevel and result = 0
  or
  result = level(p.getParent()) + 1
}

/**
 * Gets the top-most parent of `p` that is not a disjunction.
 */
AstNode getConjunctionParent(AstNode p) {
  result =
    min(int level, AstNode parent |
      parent = getConjunctionParentRec(p) and level = level(parent)
    |
      parent order by level
    )
}

from AssignedVariable var, Expr assigned1, Expr assigned2
where
  candidateRedundantAssignment(var, assigned1, assigned2) and
  getConjunctionParent(assigned1) = getConjunctionParent(assigned2) and
  // de-duplcation:
  (
    assigned1.getLocation().getStartLine() < assigned2.getLocation().getStartLine()
    or
    assigned1.getLocation().getStartLine() = assigned2.getLocation().getStartLine() and
    assigned1.getLocation().getStartColumn() < assigned2.getLocation().getStartColumn()
  )
select assigned2, "$@ has previously been assigned $@.", var, "The variable " + var.getName(),
  assigned1, "the same value"
