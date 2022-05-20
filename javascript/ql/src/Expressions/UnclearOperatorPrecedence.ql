/**
 * @name Unclear precedence of nested operators
 * @description Nested expressions involving binary bitwise operators and comparisons are easy
 *              to misunderstand without additional disambiguating parentheses or whitespace.
 * @kind problem
 * @problem.severity recommendation
 * @id js/unclear-operator-precedence
 * @tags maintainability
 *       correctness
 *       statistical
 *       non-attributable
 *       external/cwe/cwe-783
 * @precision very-high
 */

import javascript

from BitwiseBinaryExpr bit, Comparison rel, Expr other
where
  bit.hasOperands(rel, other) and
  // only flag if whitespace doesn't clarify the nesting (note that if `bit` has less
  // whitespace than `rel`, it will be reported by `js/whitespace-contradicts-precedence`)
  bit.getWhitespaceAroundOperator() = rel.getWhitespaceAroundOperator() and
  // don't flag if the other operand is itself a comparison,
  // since the nesting tends to be visually more obvious in such cases
  not other instanceof Comparison and
  // don't flag occurrences in minified code
  not rel.getTopLevel().isMinified()
select rel,
  "The '" + rel.getOperator() + "' operator binds more tightly than " + "'" + bit.getOperator() +
    "', which may not be obvious in this case."
