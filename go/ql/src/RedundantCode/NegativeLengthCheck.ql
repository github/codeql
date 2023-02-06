/**
 * @name Redundant check for negative value
 * @description Checking whether the result of 'len' or 'cap' is negative is pointless,
 *              since these functions always returns a non-negative number. It is also
 *              pointless checking if an unsigned integer is negative, as it can only
 *              hold non-negative values.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id go/negative-length-check
 * @tags correctness
 */

import go

from ComparisonExpr cmp, DataFlow::Node op, int ub, string d, string r
where
  (
    exists(BuiltinFunction bf | bf = Builtin::len() or bf = Builtin::cap() |
      op = bf.getACall() and d = "'" + bf.getName() + "'"
    )
    or
    op.getType().getUnderlyingType() instanceof UnsignedIntegerType and
    d = "This unsigned value"
  ) and
  (
    exists(RelationalComparisonExpr rel | rel = cmp |
      rel.getLesserOperand() = op.asExpr() and
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
      eq.getAnOperand() = op.asExpr() and
      eq.getAnOperand().getIntValue() = ub and
      ub < 0 and
      r = "equal"
    )
  )
select cmp, d + " is always non-negative, and hence cannot " + r + " " + ub + "."
