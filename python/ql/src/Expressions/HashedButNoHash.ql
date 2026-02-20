/**
 * @name Unhashable object hashed
 * @description Hashing an object which is not hashable will result in a TypeError at runtime.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/hash-unhashable-value
 */

import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowDispatch
private import semmle.python.ApiGraphs

/**
 * Holds if `cls` explicitly sets `__hash__` to `None`, making instances unhashable.
 */
predicate setsHashToNone(Class cls) {
  DuckTyping::getAnAttributeValue(cls, "__hash__") instanceof None
}

/**
 * Holds if `cls` is a user-defined class whose instances are unhashable.
 * A new-style class without `__hash__` is unhashable, as is one that explicitly
 * sets `__hash__ = None`.
 */
predicate isUnhashableUserClass(Class cls) {
  DuckTyping::isNewStyle(cls) and
  not DuckTyping::hasMethod(cls, "__hash__") and
  not DuckTyping::hasUnresolvedBase(getADirectSuperclass*(cls))
  or
  setsHashToNone(cls)
}

/**
 * Gets the name of a builtin type whose instances are unhashable.
 */
string getUnhashableBuiltinName() { result = ["list", "set", "dict", "bytearray"] }

/**
 * Holds if `origin` is a local source node tracking an unhashable instance that
 * flows to `node`, with `clsName` describing the class for the alert.
 */
predicate isUnhashable(DataFlow::LocalSourceNode origin, DataFlow::Node node, string clsName) {
  exists(Class c |
    isUnhashableUserClass(c) and
    origin = classInstanceTracker(c) and
    origin.flowsTo(node) and
    clsName = c.getName()
  )
  or
  clsName = getUnhashableBuiltinName() and
  origin = API::builtin(clsName).getAnInstance().asSource() and
  origin.flowsTo(node)
}

predicate explicitly_hashed(DataFlow::Node node) {
  node = API::builtin("hash").getACall().getArg(0)
}

/**
 * Holds if the subscript object in `sub[...]` is known to use hashing for indexing,
 * i.e. it does not have a custom `__getitem__` that could accept unhashable indices.
 */
predicate subscriptUsesHashing(Subscript sub) {
  DataFlow::exprNode(sub.getObject()) =
    API::builtin("dict").getAnInstance().getAValueReachableFromSource()
  or
  exists(Class cls |
    classInstanceTracker(cls)
        .(DataFlow::LocalSourceNode)
        .flowsTo(DataFlow::exprNode(sub.getObject())) and
    not DuckTyping::hasMethod(cls, "__getitem__")
  )
}

predicate unhashable_subscript(DataFlow::LocalSourceNode origin, DataFlow::Node node, string clsName) {
  exists(Subscript sub |
    node = DataFlow::exprNode(sub.getIndex()) and
    subscriptUsesHashing(sub)
  |
    isUnhashable(origin, node, clsName)
  )
}

/**
 * Holds if `e` is inside a `try` that catches `TypeError`.
 */
predicate typeerror_is_caught(Expr e) {
  exists(Try try |
    try.getBody().contains(e) and
    try.getAHandler().getType() = API::builtin("TypeError").getAValueReachableFromSource().asExpr()
  )
}

from DataFlow::LocalSourceNode origin, DataFlow::Node node, string clsName
where
  not typeerror_is_caught(node.asExpr()) and
  (
    explicitly_hashed(node) and isUnhashable(origin, node, clsName)
    or
    unhashable_subscript(origin, node, clsName)
  )
select node, "This $@ of $@ is unhashable.", origin, "instance", origin, clsName
