/**
 * @name Result of integer division may be truncated
 * @description The arguments to a division statement may be integers, which
 *              may cause the result to be truncated in Python 2.
 * @kind problem
 * @tags maintainability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/truncated-division
 */

import python

from BinaryExpr div, ControlFlowNode left, ControlFlowNode right
where
  // Only relevant for Python 2, as all later versions implement true division
  major_version() = 2 and
  exists(BinaryExprNode bin, Value lval, Value rval |
    bin = div.getAFlowNode() and
    bin.getNode().getOp() instanceof Div and
    bin.getLeft().pointsTo(lval, left) and
    lval.getClass() = ClassValue::int_() and
    bin.getRight().pointsTo(rval, right) and
    rval.getClass() = ClassValue::int_() and
    // Ignore instances where integer division leaves no remainder
    not lval.(NumericValue).getIntValue() % rval.(NumericValue).getIntValue() = 0 and
    not bin.getNode().getEnclosingModule().hasFromFuture("division") and
    // Filter out results wrapped in `int(...)`
    not exists(CallNode c |
      c = ClassValue::int_().getACall() and
      c.getAnArg() = bin
    )
  )
select div, "Result of division may be truncated as its $@ and $@ arguments may both be integers.",
  left.getLocation(), "left", right.getLocation(), "right"
