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
private import semmle.python.dataflow.new.internal.DataFlowDispatch

predicate calls_close(Call c) { exists(Attribute a | c.getFunc() = a and a.getName() = "close") }

predicate only_stmt_in_finally(Try t, Call c) {
  exists(ExprStmt s |
    t.getAFinalstmt() = s and s.getValue() = c and strictcount(t.getAFinalstmt()) = 1
  )
}

from Call close, Try t, Class cls
where
  only_stmt_in_finally(t, close) and
  calls_close(close) and
  classInstanceTracker(cls).asExpr() = close.getFunc().(Attribute).getObject() and
  DuckTyping::isContextManager(cls)
select close,
  "Instance of context-manager class $@ is closed in a finally block. Consider using 'with' statement.",
  cls, cls.getName()
