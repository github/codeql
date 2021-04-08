/**
 * @name Undefined class attribute
 * @description Accessing an attribute of 'self' that is not initialized anywhere in the class in the __init__ method may cause an AttributeError at runtime
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision low
 * @id py/undefined-attribute
 */

import python
import semmle.python.SelfAttribute
import ClassAttributes

predicate undefined_class_attribute(SelfAttributeRead a, CheckClass c, int line, string name) {
  name = a.getName() and
  not c.sometimesDefines(name) and
  c.interestingUndefined(a) and
  line = a.getLocation().getStartLine() and
  not attribute_assigned_in_method(c.getAMethodCalledFromInit(), name)
}

predicate report_undefined_class_attribute(Attribute a, ClassObject c, string name) {
  exists(int line |
    undefined_class_attribute(a, c, line, name) and
    line = min(int x | undefined_class_attribute(_, c, x, name))
  )
}

from Attribute a, ClassObject c, string name
where report_undefined_class_attribute(a, c, name)
select a, "Attribute '" + name + "' is not defined in either the class body or in any method"
