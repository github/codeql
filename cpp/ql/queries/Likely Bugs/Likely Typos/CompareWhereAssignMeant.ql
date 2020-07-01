/**
 * @name Comparison where assignment was intended
 * @description The '==' operator may have been used accidentally, where '='
 *              was intended, resulting in a useless test.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/compare-where-assign-meant
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-482
 */

import cpp

from ExprInVoidContext op
where
  not op.isUnevaluated() and
  (
    op instanceof EQExpr
    or
    op.(FunctionCall).getTarget().hasName("operator==")
  )
select op, "This '==' operator has no effect. The assignment ('=') operator was probably intended."
