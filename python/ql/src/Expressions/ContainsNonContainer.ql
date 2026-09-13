/**
 * @name Membership test with a non-container
 * @description A membership test, such as 'item in sequence', with a non-container on the right hand side will raise a 'TypeError'.
 * @kind path-problem
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
private import semmle.python.dataflow.new.internal.ClassInstanceFlow
private import semmle.python.ApiGraphs

predicate rhs_in_expr(Expr rhs, Compare cmp) {
  exists(Cmpop op, int i | cmp.getOp(i) = op and cmp.getComparator(i) = rhs |
    op instanceof In or op instanceof NotIn
  )
}

module ContainsNonContainerSig implements ClassInstanceFlowSig {
  predicate isRelevantClass(Class cls) {
    not DuckTyping::isContainer(cls) and
    not DuckTyping::hasUnresolvedBase(getADirectSuperclass*(cls)) and
    not exists(CallNode setattr_call |
      setattr_call.getFunction().(NameNode).getId() = "setattr" and
      setattr_call.getArg(0).(NameNode).getId() = cls.getName() and
      setattr_call.getScope() = cls.getScope()
    )
  }

  predicate isInstanceSink(DataFlow::Node sink) { rhs_in_expr(sink.asExpr(), _) }

  predicate isGuardType(DataFlow::Node checkedType) {
    checkedType =
      API::builtin(["list", "tuple", "set", "frozenset", "dict", "str", "bytes", "bytearray"])
          .getAValueReachableFromSource()
  }
}

module ContainsNonContainerFlow = ClassInstanceFlow<ContainsNonContainerSig>;

import ContainsNonContainerFlow::Flow::PathGraph

from
  ContainsNonContainerFlow::Flow::PathNode source, ContainsNonContainerFlow::Flow::PathNode sink,
  ClassExpr ce
where
  ContainsNonContainerFlow::Flow::flowPath(source, sink) and
  source.getNode().asExpr() = ce
select sink.getNode(), source, sink,
  "This test may raise an Exception as the $@ may be of non-container class $@.", source.getNode(),
  "target", ce.getInnerScope(), ce.getInnerScope().getName()
