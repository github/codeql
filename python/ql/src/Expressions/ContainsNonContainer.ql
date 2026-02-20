/**
 * @name Membership test with a non-container
 * @description A membership test, such as 'item in sequence', with a non-container on the right hand side will raise a 'TypeError'.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/member-test-non-container
 */

import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate rhs_in_expr(Expr rhs, Compare cmp) {
  exists(Cmpop op, int i | cmp.getOp(i) = op and cmp.getComparator(i) = rhs |
    op instanceof In or op instanceof NotIn
  )
}

from Compare cmp, DataFlow::LocalSourceNode origin, DataFlow::Node rhs, Class cls
where
  origin = classInstanceTracker(cls) and
  origin.flowsTo(rhs) and
  not DuckTyping::isContainer(cls) and
  not DuckTyping::hasUnresolvedBase(getADirectSuperclass*(cls)) and
  rhs_in_expr(rhs.asExpr(), cmp)
select cmp, "This test may raise an Exception as the $@ may be of non-container class $@.", origin,
  "target", cls, cls.getName()
