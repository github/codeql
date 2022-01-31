/**
 * @name Use a set literal in place of `or`
 * @description A chain of `or`s can be replaced with a set literal, improving readability.
 * @kind problem
 * @problem.severity recommendation
 * @id ql/use-set-literal
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.style.UseSetLiteralQuery

from DisjunctionChain d, string msg, int c
where
  (
    d instanceof DisjunctionEqualsLiteral and
    msg =
      "This formula of " + c.toString() +
        " comparisons can be replaced with a single equality on a set literal, improving readability."
    or
    d instanceof DisjunctionPredicateLiteral and
    msg =
      "This formula of " + c.toString() +
        " predicate calls can be replaced with a single call on a set literal, improving readability."
  ) and
  c = count(d.getOperand(_)) and
  c >= 4
select d, msg
