/**
 * @name Superclass attribute shadows subclass method
 * @description Defining an attribute in a superclass method with a name that matches a subclass
 *              method, hides the method in the subclass.
 * @kind problem
 * @problem.severity error
 * @tags maintainability
 *       correctness
 * @sub-severity low
 * @precision high
 * @id py/attribute-shadows-method
 */

/*
 * Determine if a class defines a method that is shadowed by an attribute
 *   defined in a super-class
 */

/* Need to find attributes defined in superclass (only in __init__?) */
import python

predicate shadowed_by_super_class(
  ClassObject c, ClassObject supercls, Assign assign, FunctionObject f
) {
  c.getASuperType() = supercls and
  c.declaredAttribute(_) = f and
  exists(FunctionObject init, Attribute attr |
    supercls.declaredAttribute("__init__") = init and
    attr = assign.getATarget() and
    attr.getObject().(Name).getId() = "self" and
    attr.getName() = f.getName() and
    assign.getScope() = init.getOrigin().(FunctionExpr).getInnerScope()
  ) and
  /*
   * It's OK if the super class defines the method as well.
   * We assume that the original method must have been defined for a reason.
   */

  not supercls.hasAttribute(f.getName())
}

from ClassObject c, ClassObject supercls, Assign assign, FunctionObject shadowed
where shadowed_by_super_class(c, supercls, assign, shadowed)
select shadowed.getOrigin(),
  "Method " + shadowed.getName() + " is shadowed by $@ in super class '" + supercls.getName() + "'.",
  assign, "an attribute"
