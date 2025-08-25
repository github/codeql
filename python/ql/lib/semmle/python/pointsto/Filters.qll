/**
 * Helper predicates for standard tests in Python commonly
 * used to filter objects by value or by type.
 */

import python

/** Holds if `c` is a call to `hasattr(obj, attr)`. */
predicate hasattr(CallNode c, ControlFlowNode obj, string attr) {
  c.getFunction().getNode().(Name).getId() = "hasattr" and
  c.getArg(0) = obj and
  c.getArg(1).getNode().(StringLiteral).getText() = attr
}

/** Holds if `c` is a call to `isinstance(use, cls)`. */
predicate isinstance(CallNode fc, ControlFlowNode cls, ControlFlowNode use) {
  fc.getFunction().(NameNode).getId() = "isinstance" and
  cls = fc.getArg(1) and
  fc.getArg(0) = use
}

/** Holds if `c` is a test comparing `x` and `y`. `is` is true if the operator is `is` or `==`, it is false if the operator is `is not` or `!=`. */
predicate equality_test(CompareNode c, ControlFlowNode x, boolean is, ControlFlowNode y) {
  exists(Cmpop op |
    c.operands(x, op, y) or
    c.operands(y, op, x)
  |
    (
      is = true and op instanceof Is
      or
      is = false and op instanceof IsNot
      or
      is = true and op instanceof Eq
      or
      is = false and op instanceof NotEq
    )
  )
}
