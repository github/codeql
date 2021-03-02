/**
 * @name Assignment in Boolean expression
 * @description Assignments in Boolean conditions can be confused with equality tests and make the
 *              condition more difficult to understand.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/assignment-in-boolean-expression
 * @tags reliability
 *       readability
 *       external/cwe/cwe-481
 */

import semmle.code.java.Expr
import semmle.code.java.Statement

/** An expression that is used as a condition. */
class BooleanExpr extends Expr {
  BooleanExpr() {
    this = any(ConditionalStmt s).getCondition() or
    this = any(ConditionalExpr s).getCondition()
  }
}

private predicate assignAndCheck(AssignExpr e) {
  exists(BinaryExpr c | e = c.getAChildExpr() |
    c instanceof ComparisonExpr or
    c instanceof EqualityTest
  )
}

from AssignExpr a
where
  exists(BooleanExpr expr | expr.getAChildExpr*() = a) and
  not assignAndCheck(a)
select a, "Assignment in a boolean expression."
