/**
 * @name C-style condition
 * @description Putting parentheses around a condition in an 'if' or 'while' statement is
 *              unnecessary and harder to read.
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity low
 * @deprecated
 * @precision very-high
 * @id py/c-style-parentheses
 */

import python

from Expr e, Location l, string kind, string what
where
  e.isParenthesized() and
  not e instanceof Tuple and
  (
    exists(If i | i.getTest() = e) and kind = "if" and what = "condition"
    or
    exists(While w | w.getTest() = e) and kind = "while" and what = "condition"
    or
    exists(Return r | r.getValue() = e) and kind = "return" and what = "value"
    or
    exists(Assert a | a.getTest() = e and not exists(a.getMsg())) and
    kind = "assert" and
    what = "test"
  ) and
  // These require parentheses
  (not e instanceof Yield and not e instanceof YieldFrom and not e instanceof GeneratorExp) and
  l = e.getLocation() and
  l.getStartLine() = l.getEndLine()
select e, "Parenthesized " + what + " in '" + kind + "' statement."
