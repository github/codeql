/**
 * @name Inefficient string comparison
 * @description The `.matches` predicate is usually the best performing way to compare strings.
 * @kind problem
 * @problem.severity error
 * @id ql/inefficient-string-comparison
 * @tags performance
 * @precision high
 */

import ql
import codeql_ql.performance.InefficientStringComparisonQuery

from AstNode node, string msg
where
  exists(EqFormula eq, FixPredicateCall call, String literal |
    node = eq and msg = "Use " + getMessage(call, literal) + " instead."
  |
    eq.getAnOperand() = call and eq.getAnOperand() = literal
  )
  or
  exists(string matchesStr |
    canUseMatchInsteadOfRegexpMatch(node, matchesStr) and
    msg = "Use matches(\"" + matchesStr + "\") instead"
  )
select node, msg
