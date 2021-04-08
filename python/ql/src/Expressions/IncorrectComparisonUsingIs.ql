/**
 * @name Comparison using is when operands support __eq__
 * @description Comparison using 'is' when equivalence is not the same as identity
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity low
 * @precision high
 * @id py/comparison-using-is
 */

import python
import IsComparisons

from Compare comp, Cmpop op, ClassValue c, string alt
where
  invalid_portable_is_comparison(comp, op, c) and
  not cpython_interned_constant(comp.getASubExpression()) and
  (
    op instanceof Is and alt = "=="
    or
    op instanceof IsNot and alt = "!="
  )
select comp,
  "Values compared using '" + op.getSymbol() +
    "' when equivalence is not the same as identity. Use '" + alt + "' instead."
