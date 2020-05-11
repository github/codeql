/**
 * @name First parameter of a class method is not named 'cls'
 * @description Using an alternative name for the first parameter of a class method makes code more
 *              difficult to read; PEP8 states that the first parameter to class methods should be 'cls'.
 * @kind problem
 * @tags maintainability
 *       readability
 *       convention
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/not-named-cls
 */

import python

predicate first_arg_cls(Function f) {
  exists(string argname | argname = f.getArgName(0) |
    argname = "cls"
    or
    /* Not PEP8, but relatively common */
    argname = "mcls"
  )
}

predicate is_type_method(Function f) {
  exists(ClassValue c | c.getScope() = f.getScope() and c.getASuperType() = ClassValue::type())
}

predicate classmethod_decorators_only(Function f) {
  forall(Expr decorator | decorator = f.getADecorator() | decorator.(Name).getId() = "classmethod")
}

from Function f, string message
where
  (f.getADecorator().(Name).getId() = "classmethod" or is_type_method(f)) and
  not first_arg_cls(f) and
  classmethod_decorators_only(f) and
  not f.getName() = "__new__" and
  (
    if exists(f.getArgName(0))
    then
      message =
        "Class methods or methods of a type deriving from type should have 'cls', rather than '" +
          f.getArgName(0) + "', as their first parameter."
    else
      message =
        "Class methods or methods of a type deriving from type should have 'cls' as their first parameter."
  )
select f, message
