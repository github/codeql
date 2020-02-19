/**
 * @name Check for negative length
 * @description Checking whether the result of 'len' or 'cap' is negative is pointless,
 *              since these functions always returns a non-negative number.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id go/negative-length-check
 * @tags correctness
 */

import go

from ComparisonExpr cmp, BuiltinFunction len, int ub, string r
where
  (len = Builtin::len() or len = Builtin::cap()) and
  (
    exists(RelationalComparisonExpr rel | rel = cmp |
      rel.getLesserOperand() = len.getACall().asExpr() and
      rel.getGreaterOperand().getIntValue() = ub and
      (
        ub < 0
        or
        ub = 0 and rel.isStrict()
      ) and
      r = "be less than"
    )
    or
    exists(EqualityTestExpr eq | eq = cmp |
      eq.getAnOperand() = len.getACall().asExpr() and
      eq.getAnOperand().getIntValue() = ub and
      ub < 0 and
      r = "equal"
    )
  )
select cmp, "'" + len.getName() + "' is always non-negative, and hence cannot " + r + " " + ub + "."
