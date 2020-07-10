/**
 * @name Non-portable comparison using is when operands support __eq__
 * @description Comparison using 'is' when equivalence is not the same as identity and may not be portable.
 * @kind problem
 * @tags portability
 *       maintainability
 * @problem.severity recommendation
 * @sub-severity low
 * @precision medium
 * @id py/comparison-using-is-non-portable
 */

import python
import IsComparisons

from Compare comp, Cmpop op, ClassValue c
where
  invalid_portable_is_comparison(comp, op, c) and
  exists(Expr sub | sub = comp.getASubExpression() |
    cpython_interned_constant(sub) and
    not universally_interned_constant(sub)
  )
select comp,
  "The result of this comparison with '" + op.getSymbol() +
    "' may differ between implementations of Python."
