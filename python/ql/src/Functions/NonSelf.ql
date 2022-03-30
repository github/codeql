/**
 * @name First parameter of a method is not named 'self'
 * @description Using an alternative name for the first parameter of an instance method makes
 *              code more difficult to read; PEP8 states that the first parameter to instance
 *              methods should be 'self'.
 * @kind problem
 * @tags maintainability
 *       readability
 *       convention
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/not-named-self
 */

import python
import semmle.python.libraries.Zope

predicate is_type_method(FunctionValue fv) {
  exists(ClassValue c | c.declaredAttribute(_) = fv and c.getASuperType() = ClassValue::type())
}

predicate used_in_defining_scope(FunctionValue fv) {
  exists(Call c | c.getScope() = fv.getScope().getScope() and c.getFunc().pointsTo(fv))
}

from Function f, FunctionValue fv, string message
where
  exists(ClassValue cls, string name |
    cls.declaredAttribute(name) = fv and
    cls.isNewStyle() and
    not name = "__new__" and
    not name = "__metaclass__" and
    not name = "__init_subclass__" and
    not name = "__class_getitem__" and
    /* declared in scope */
    f.getScope() = cls.getScope()
  ) and
  not f.getArgName(0) = "self" and
  not is_type_method(fv) and
  fv.getScope() = f and
  not f.getName() = "lambda" and
  not used_in_defining_scope(fv) and
  (
    (
      if exists(f.getArgName(0))
      then
        message =
          "Normal methods should have 'self', rather than '" + f.getArgName(0) +
            "', as their first parameter."
      else
        message =
          "Normal methods should have at least one parameter (the first of which should be 'self')."
    ) and
    not f.hasVarArg()
  ) and
  not fv instanceof ZopeInterfaceMethodValue
select f, message
