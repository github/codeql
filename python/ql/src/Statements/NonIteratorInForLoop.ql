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

from For loop, ControlFlowNode iter, ClassObject t, ControlFlowNode origin
where loop.getIter().getAFlowNode() = iter and
iter.refersTo(_, t, origin) and 
not t.isIterable() and not t.failedInference() and
not t = theNoneType() and
not t.isDescriptorType()

select loop, "$@ of class '$@' may be used in for-loop.", origin, "Non-iterator", t, t.getName()
