/**
 * @name Comparison of identical values
 * @description If the same expression occurs on both sides of a comparison
 *              operator, the operator is redundant, and probably indicates a mistake.
 * @kind problem
 * @problem.severity warning
 * @id go/comparison-of-identical-expressions
 * @tags correctness
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @precision very-high
 */

import go

from ComparisonExpr cmp, Expr l
where
  l = cmp.getLeftOperand() and
  l.getGlobalValueNumber() = cmp.getRightOperand().getGlobalValueNumber() and
  // allow floats, where self-comparison may be used for NaN checks
  not l.getType().getUnderlyingType() instanceof FloatType and
  // allow comparisons of symbolic constants to literal constants; these are often feature flags
  not exists(DeclaredConstant decl |
    cmp.getAnOperand() = decl.getAReference() and
    cmp.getAnOperand() instanceof BasicLit
  )
select cmp, "This expression compares $@ to itself.", cmp.getLeftOperand(), "an expression"
