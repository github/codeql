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

from For loop, Expr iter, Class cls
where
  iter = loop.getIter() and
  classInstanceTracker(cls).asExpr() = iter and
  not DuckTyping::isIterable(cls) and
  not DuckTyping::isDescriptor(cls) and
  not (loop.isAsync() and DuckTyping::hasMethod(cls, "__aiter__")) and
  not DuckTyping::hasUnresolvedBase(getADirectSuperclass*(cls))
select loop, "This for-loop may attempt to iterate over a $@ of class $@.", iter,
  "non-iterable instance", cls, cls.getName()
