/**
 * @name Inconsistent equality and inequality
 * @description Defining only an equality method or an inequality method for a class violates the object model.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/inconsistent-equality
 */

import python
import Equality

string equals_or_ne() { result = "__eq__" or result = "__ne__" }

predicate total_ordering(Class cls) {
  exists(Attribute a | a = cls.getADecorator() | a.getName() = "total_ordering")
  or
  exists(Name n | n = cls.getADecorator() | n.getId() = "total_ordering")
}

CallableValue implemented_method(ClassValue c, string name) {
  result = c.declaredAttribute(name) and name = equals_or_ne()
}

string unimplemented_method(ClassValue c) {
  not c.declaresAttribute(result) and result = equals_or_ne()
}

predicate violates_equality_contract(
  ClassValue c, string present, string missing, CallableValue method
) {
  missing = unimplemented_method(c) and
  method = implemented_method(c, present) and
  not c.failedInference(_) and
  not total_ordering(c.getScope()) and
  /* Python 3 automatically implements __ne__ if __eq__ is defined, but not vice-versa */
  not (major_version() = 3 and present = "__eq__" and missing = "__ne__") and
  not method.getScope() instanceof DelegatingEqualityMethod and
  not c.lookup(missing).(CallableValue).getScope() instanceof DelegatingEqualityMethod
}

from ClassValue c, string present, string missing, CallableValue method
where violates_equality_contract(c, present, missing, method)
select method, "Class $@ implements " + present + " but does not implement " + missing + ".", c,
  c.getName()
