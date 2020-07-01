/**
 * @name AV Rule 213
 * @description No dependence shall be placed on C++'s operator precedence rules,
 *              below arithmetic operators, in expressions.
 * @kind problem
 * @id cpp/jsf/av-rule-213
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/*
 * Interpretation and deviations:
 *   - if the higher operator has precedence > arithmetic then it is fine
 *     RATIONALE: exprs like `f()`, `*x`, `&x` are easily understood to bind tightly
 *   - if the higher operator is the RHS of an assign then it is fine
 *     RATIONALE: cf. MISRA, too many cases excluded otherwise
 *   - comparison operators can be mixed with arithmetic
 *     RATIONALE: `x==y+z` is common and unambiguous
 */

predicate arithmeticPrecedence(int p) { p = 12 or p = 13 }

predicate comparisonPrecedence(int p) { p = 9 or p = 10 }

from Expr e1, Expr e2, int p1, int p2
where
  e1.getAChild() = e2 and
  p1 = e1.getPrecedence() and
  p2 = e2.getPrecedence() and
  p1 < p2 and
  not e2.isParenthesised() and
  p1 <= 11 and
  p2 <= 13 and // allow > arithmetic operators
  not (arithmeticPrecedence(p2) and comparisonPrecedence(p1)) and // arith-compare deviation
  not e2 = e1.(Assignment).getRValue() // assignment deviation
select e1, "AV Rule 213: Limited dependence shall be placed on operator precedence rules."
