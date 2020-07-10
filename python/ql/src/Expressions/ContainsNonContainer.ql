/**
 * @name Membership test with a non-container
 * @description A membership test, such as 'item in sequence', with a non-container on the right hand side will raise a 'TypeError'.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/member-test-non-container
 */

import python
import semmle.python.pointsto.PointsTo

predicate rhs_in_expr(ControlFlowNode rhs, Compare cmp) {
  exists(Cmpop op, int i | cmp.getOp(i) = op and cmp.getComparator(i) = rhs.getNode() |
    op instanceof In or op instanceof NotIn
  )
}

from ControlFlowNode non_seq, Compare cmp, Value v, ClassValue cls, ControlFlowNode origin
where
  rhs_in_expr(non_seq, cmp) and
  non_seq.pointsTo(_, v, origin) and
  v.getClass() = cls and
  not Types::failedInference(cls, _) and
  not cls.hasAttribute("__contains__") and
  not cls.hasAttribute("__iter__") and
  not cls.hasAttribute("__getitem__") and
  not cls = ClassValue::nonetype() and
  not cls = Value::named("types.MappingProxyType")
select cmp, "This test may raise an Exception as the $@ may be of non-container class $@.", origin,
  "target", cls, cls.getName()
