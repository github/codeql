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
private import semmle.python.dataflow.new.internal.ReExposedInstance

predicate calls_close(Call c) { exists(Attribute a | c.getFunc() = a and a.getName() = "close") }

predicate only_stmt_in_finally(Try t, Call c) {
  exists(ExprStmt s |
    t.getAFinalstmt() = s and s.getValue() = c and strictcount(t.getAFinalstmt()) = 1
  )
}

/** Holds if `node` is tracked to be an instance of some class. */
private predicate classInstanceNode(DataFlow::Node node) { node = classInstanceTracker(_) }

private module ClassReExposed = ReExposedInstance<classInstanceNode/1>;

from Call close, Try t, Class cls, DataFlow::Node closeTarget
where
  only_stmt_in_finally(t, close) and
  calls_close(close) and
  closeTarget.asExpr() = close.getFunc().(Attribute).getObject() and
  closeTarget = classInstanceTracker(cls) and
  // Don't report closing a resource that is held in an instance attribute (e.g. `self.reader`).
  // Such flow is introduced by instance-attribute type tracking; the object's lifetime is tied
  // to the enclosing instance and cannot be expressed with a `with` statement.
  not ClassReExposed::isReExposed(closeTarget) and
  DuckTyping::isContextManager(cls)
select close,
  "Instance of context-manager class $@ is closed in a finally block. Consider using 'with' statement.",
  cls, cls.getName()
