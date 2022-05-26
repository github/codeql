/**
 * Provides predicates for working with useless conditionals.
 */

import javascript

/**
 * Holds if `e` is part of a conditional node `cond` that evaluates
 * `e` and checks its value for truthiness, and the return value of `e`
 * is not used for anything other than this truthiness check.
 */
predicate isExplicitConditional(AstNode cond, Expr e) {
  e = cond.(IfStmt).getCondition()
  or
  e = cond.(LoopStmt).getTest()
  or
  e = cond.(ConditionalExpr).getCondition()
  or
  isExplicitConditional(_, cond) and
  e = cond.(Expr).getUnderlyingValue().(LogicalBinaryExpr).getAnOperand()
}
