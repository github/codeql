/**
 * @name Comparison of narrow type with wide type in loop condition
 * @description Comparisons between types of different widths in a loop condition can cause the loop
 *              to behave unexpectedly.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision medium
 * @id java/comparison-with-wider-type
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-197
 */

import java
import semmle.code.java.arithmetic.Overflow

int widthRank(Expr e) { result = e.getType().(NumType).getWidthRank() }

predicate wideningComparison(ComparisonExpr c, Expr lesserOperand, Expr greaterOperand) {
  lesserOperand = c.getLesserOperand() and
  greaterOperand = c.getGreaterOperand() and
  widthRank(lesserOperand) < widthRank(greaterOperand)
}

from ComparisonExpr c, LoopStmt l, Expr lesserOperand, Expr greaterOperand
where
  wideningComparison(c, lesserOperand, greaterOperand) and
  not c.getAnOperand().isCompileTimeConstant() and
  l.getCondition().getAChildExpr*() = c
select c,
  "Comparison between $@ of type " + lesserOperand.getType().getName() + " and $@ of wider type " +
    greaterOperand.getType().getName() + ".", lesserOperand, "expression", greaterOperand,
  "expression"
