/**
 * @name Non-iterable used in for loop
 * @description Using a non-iterable as the object in a 'for' loop causes a TypeError.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/non-iterable-in-for-loop
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.ApiGraphs

/**
 * Holds if `cls_arg` references a known iterable builtin type, either directly
 * (e.g. `list`) or as an element of a tuple (e.g. `(list, tuple)`).
 */
private predicate isIterableTypeArg(DataFlow::Node cls_arg) {
  cls_arg =
    API::builtin([
        "list", "tuple", "set", "frozenset", "dict", "str", "bytes", "bytearray", "range",
        "memoryview"
      ]).getAValueReachableFromSource()
  or
  isIterableTypeArg(DataFlow::exprNode(cls_arg.asExpr().(Tuple).getAnElt()))
}

/**
 * Holds if `iter` is guarded by an `isinstance` check that tests for
 * an iterable type (e.g. `list`, `tuple`, `set`, `dict`).
 */
predicate guardedByIsinstanceIterable(DataFlow::Node iter) {
  exists(
    DataFlow::GuardNode guard, DataFlow::CallCfgNode isinstance_call, DataFlow::LocalSourceNode src
  |
    isinstance_call = API::builtin("isinstance").getACall() and
    src.flowsTo(isinstance_call.getArg(0)) and
    src.flowsTo(iter) and
    isIterableTypeArg(isinstance_call.getArg(1)) and
    guard = isinstance_call.asCfgNode() and
    guard.controlsBlock(iter.asCfgNode().getBasicBlock(), true)
  )
}

from For loop, DataFlow::Node iter, Class cls
where
  iter.asExpr() = loop.getIter() and
  iter = classInstanceTracker(cls) and
  not DuckTyping::isIterable(cls) and
  not DuckTyping::isDescriptor(cls) and
  not (loop.isAsync() and DuckTyping::hasMethod(cls, "__aiter__")) and
  not DuckTyping::hasUnresolvedBase(getADirectSuperclass*(cls)) and
  not guardedByIsinstanceIterable(iter)
select loop, "This for-loop may attempt to iterate over a $@ of class $@.", iter.asExpr(),
  "non-iterable instance", cls, cls.getName()
