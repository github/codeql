/**
 * @name Non-iterable used in for loop
 * @description Using a non-iterable as the object in a 'for' loop causes a TypeError.
 * @kind problem
 * @tags reliability
 *       correctness
 *       types
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/non-iterable-in-for-loop
 */

import python

from For loop, ControlFlowNode iter, Value v, ClassValue t, ControlFlowNode origin
where
  loop.getIter().getAFlowNode() = iter and
  iter.pointsTo(_, v, origin) and
  v.getClass() = t and
  not t.isIterable() and
  not t.failedInference(_) and
  not v = Value::named("None") and
  not t.isDescriptorType()
select loop, "$@ of class '$@' may be used in for-loop.", origin, "Non-iterable", t, t.getName()
