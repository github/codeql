/**
 * @name Comparison of identical values
 * @description If the same expression occurs on both sides of a comparison
 *              operator, the operator is redundant, and probably indicates a mistake.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/comparison-of-identical-expressions
 * @tags reliability
 *       correctness
 *       logic
 */

import java

predicate comparison(BinaryExpr binop, Expr left, Expr right) {
  (binop instanceof ComparisonExpr or binop instanceof EqualityTest) and
  binop.getLeftOperand() = left and
  binop.getRightOperand() = right
}

/**
 * Are `left` and `right` in syntactic positions where we might want to compare
 * them for structural equality?
 *
 * Note that this is an overapproximation: it only checks that `left` and
 * `right` are at the same depth below a comparison.
 */
predicate toCompare(Expr left, Expr right) {
  comparison(_, left, right) or
  toCompare(left.getParent(), right.getParent())
}

pragma[noinline]
predicate varsToCompare(VarAccess left, VarAccess right, Variable v1, Variable v2) {
  toCompare(left, right) and
  left.getVariable() = v1 and
  right.getVariable() = v2
}

/** Are `left` and `right` accesses to `v` on the same object? */
predicate sameVariable(VarAccess left, VarAccess right, Variable v) {
  varsToCompare(left, right, v, v) and
  (
    sameVariable(left.getQualifier(), right.getQualifier(), _)
    or
    left.isLocal() and right.isLocal()
  )
}

/** Are `left` and `right` structurally equal? */
predicate equal(Expr left, Expr right) {
  toCompare(left, right) and
  (
    left.(Literal).getValue() = right.(Literal).getValue()
    or
    sameVariable(left, right, _)
    or
    exists(BinaryExpr bLeft, BinaryExpr bRight | bLeft = left and bRight = right |
      bLeft.getKind() = bRight.getKind() and
      equal(bLeft.getLeftOperand(), bRight.getLeftOperand()) and
      equal(bLeft.getRightOperand(), bRight.getRightOperand())
    )
  )
}

predicate specialCase(EqualityTest comparison, string msg) {
  exists(FloatingPointType fptp, string neg, string boxedName |
    fptp = comparison.getAnOperand().getType() and
    // Name of boxed type corresponding to `fptp`.
    (if fptp.getName().toLowerCase() = "float" then boxedName = "Float" else boxedName = "Double") and
    // Equality tests are tests for not-`NaN`, inequality tests for `NaN`.
    (if comparison instanceof EQExpr then neg = "!" else neg = "") and
    msg = "equivalent to " + neg + boxedName + ".isNaN(" + comparison.getLeftOperand() + ")"
  )
}

from BinaryExpr comparison, Expr left, Expr right, string msg, string equiv
where
  comparison(comparison, left, right) and
  equal(left, right) and
  (
    specialCase(comparison, equiv) and msg = "Comparison is " + equiv
    or
    not specialCase(comparison, _) and
    msg = "Comparison of identical values " + left + " and " + right and
    equiv = ""
  )
select comparison, msg + "."
