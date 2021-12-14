/**
 * @name Unclear comparison precedence
 * @description Using comparisons as operands of other comparisons is unusual
 *              in itself, and most readers will require parentheses to be sure
 *              of the precedence.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/comparison-precedence
 * @tags maintainability
 *       readability
 */

import cpp

from ComparisonOperation co, ComparisonOperation chco
where
  co.getAChild() = chco and
  not chco.isParenthesised() and
  not co.isFromUninstantiatedTemplate(_)
select co, "Comparison as an operand to another comparison."
