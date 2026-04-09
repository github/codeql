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
private import semmle.python.ApiGraphs

predicate rhs_in_expr(Expr rhs, Compare cmp) {
  exists(Cmpop op, int i | cmp.getOp(i) = op and cmp.getComparator(i) = rhs |
    op instanceof In or op instanceof NotIn
  )
}

/**
 * Holds if `origin` is the result of applying a class as a decorator to a function.
 * Such decorator classes act as proxies, and the runtime value of the decorated
 * attribute may be of a different type than the decorator class itself.
 */
predicate isDecoratorApplication(DataFlow::LocalSourceNode origin) {
  exists(FunctionExpr fe | origin.asExpr() = fe.getADecoratorCall())
}

/**
 * Holds if `cls` has methods dynamically added via `setattr`, so we cannot
 * statically determine its full interface.
 */
predicate hasDynamicMethods(Class cls) {
  exists(CallNode setattr_call |
    setattr_call.getFunction().(NameNode).getId() = "setattr" and
    setattr_call.getArg(0).(NameNode).getId() = cls.getName() and
    setattr_call.getScope() = cls.getScope()
  )
}

/**
 * Holds if `cls_arg` references a known container builtin type, either directly
 * or as an element of a tuple.
 */
private predicate isContainerTypeArg(DataFlow::Node cls_arg) {
  cls_arg =
    API::builtin(["list", "tuple", "set", "frozenset", "dict", "str", "bytes", "bytearray"])
        .getAValueReachableFromSource()
  or
  isContainerTypeArg(DataFlow::exprNode(cls_arg.asExpr().(Tuple).getAnElt()))
}

/**
 * Holds if `rhs` is guarded by an `isinstance` check that tests for
 * a container type.
 */
predicate guardedByIsinstanceContainer(DataFlow::Node rhs) {
  exists(
    DataFlow::GuardNode guard, DataFlow::CallCfgNode isinstance_call, DataFlow::LocalSourceNode src
  |
    isinstance_call = API::builtin("isinstance").getACall() and
    src.flowsTo(isinstance_call.getArg(0)) and
    src.flowsTo(rhs) and
    isContainerTypeArg(isinstance_call.getArg(1)) and
    guard = isinstance_call.asCfgNode() and
    guard.controlsBlock(rhs.asCfgNode().getBasicBlock(), true)
  )
}

from Compare cmp, DataFlow::LocalSourceNode origin, DataFlow::Node rhs, Class cls
where
  origin = classInstanceTracker(cls) and
  origin.flowsTo(rhs) and
  not DuckTyping::isContainer(cls) and
  not DuckTyping::hasUnresolvedBase(getADirectSuperclass*(cls)) and
  not isDecoratorApplication(origin) and
  not hasDynamicMethods(cls) and
  not guardedByIsinstanceContainer(rhs) and
  rhs_in_expr(rhs.asExpr(), cmp)
select cmp, "This test may raise an Exception as the $@ may be of non-container class $@.", origin,
  "target", cls, cls.getName()
