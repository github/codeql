/**
 * @name Maybe undefined class attribute
 * @description Accessing an attribute of `self` that is not initialized in the `__init__` method may cause an AttributeError at runtime
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision low
 * @id py/maybe-undefined-attribute
 */

import python
import semmle.python.SelfAttribute
import ClassAttributes

predicate guarded_by_other_attribute(SelfAttributeRead a, CheckClass c) {
  c.sometimesDefines(a.getName()) and
  exists(SelfAttributeRead guard, If i |
    i.contains(a) and
    c.assignedInInit(guard.getName())
  |
    i.getTest() = guard
    or
    i.getTest().contains(guard)
  )
}

predicate maybe_undefined_class_attribute(SelfAttributeRead a, CheckClass c) {
  c.sometimesDefines(a.getName()) and
  not c.alwaysDefines(a.getName()) and
  c.interestingUndefined(a) and
  not guarded_by_other_attribute(a, c)
}

from Attribute a, ClassObject c, SelfAttributeStore sa
where
  maybe_undefined_class_attribute(a, c) and
  sa.getClass() = c.getPyClass() and
  sa.getName() = a.getName()
select a,
  "Attribute '" + a.getName() +
    "' is not defined in the class body nor in the __init__() method, but it is defined $@", sa,
  "here"
