/**
 * @name Should use a 'with' statement
 * @description Using a 'try-finally' block to ensure only that a resource is closed makes code more
 *              difficult to read.
 * @kind problem
 * @tags quality
 *       maintainability
 *       readability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/should-use-with
 */

import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate calls_close(Call c) { exists(Attribute a | c.getFunc() = a and a.getName() = "close") }

predicate only_stmt_in_finally(Try t, Call c) {
  exists(ExprStmt s |
    t.getAFinalstmt() = s and s.getValue() = c and strictcount(t.getAFinalstmt()) = 1
  )
}

/**
 * Holds if `read` is an attribute read that re-exposes an instance of `cls` held in an
 * instance attribute, for example `BufferedRWPair.reader`.
 *
 * Instance-attribute type tracking can launder such an instance out of a field. The object
 * is owned by the enclosing instance, so its lifetime spans that instance and cannot be
 * expressed with a `with` statement; closing it in a `finally` block is therefore not a
 * candidate for refactoring.
 */
private predicate launderedAttrRead(Class cls, DataFlow::AttrRead read) {
  read = classInstanceTracker(cls)
}

/** Type tracking forward from an attribute read that re-exposes an instance held in a field. */
private DataFlow::TypeTrackingNode launderedInstance(Class cls, DataFlow::TypeTracker t) {
  t.start() and
  launderedAttrRead(cls, result)
  or
  exists(DataFlow::TypeTracker t2 | result = launderedInstance(cls, t2).track(t2, t))
}

from Call close, Try t, Class cls, DataFlow::Node closeTarget
where
  only_stmt_in_finally(t, close) and
  calls_close(close) and
  closeTarget.asExpr() = close.getFunc().(Attribute).getObject() and
  closeTarget = classInstanceTracker(cls) and
  // Don't report closing a resource that is held in an instance attribute (e.g. `self.reader`).
  // Such flow is introduced by instance-attribute type tracking; the object's lifetime is tied
  // to the enclosing instance and cannot be expressed with a `with` statement.
  not launderedInstance(cls, DataFlow::TypeTracker::end()).flowsTo(closeTarget) and
  DuckTyping::isContextManager(cls)
select close,
  "Instance of context-manager class $@ is closed in a finally block. Consider using 'with' statement.",
  cls, cls.getName()
