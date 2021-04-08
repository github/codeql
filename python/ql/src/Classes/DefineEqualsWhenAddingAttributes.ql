/**
 * @name __eq__ not overridden when adding attributes
 * @description When adding new attributes to instances of a class, equality for that class needs to be defined.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision high
 * @id py/missing-equals
 */

import python
import semmle.python.SelfAttribute
import Equality

predicate class_stores_to_attribute(ClassValue cls, SelfAttributeStore store, string name) {
  exists(FunctionValue f |
    f = cls.declaredAttribute(_) and store.getScope() = f.getScope() and store.getName() = name
  ) and
  /* Exclude classes used as metaclasses */
  not cls.getASuperType() = ClassValue::type()
}

predicate should_override_eq(ClassValue cls, Value base_eq) {
  not cls.declaresAttribute("__eq__") and
  exists(ClassValue sup | sup = cls.getABaseType() and sup.declaredAttribute("__eq__") = base_eq |
    not exists(GenericEqMethod eq | eq.getScope() = sup.getScope()) and
    not exists(IdentityEqMethod eq | eq.getScope() = sup.getScope()) and
    not base_eq.(FunctionValue).getScope() instanceof IdentityEqMethod and
    not base_eq = ClassValue::object().declaredAttribute("__eq__")
  )
}

/**
 * Does the non-overridden __eq__ method access the attribute,
 * which implies that the  __eq__ method does not need to be overridden.
 */
predicate superclassEqExpectsAttribute(ClassValue cls, FunctionValue base_eq, string attrname) {
  not cls.declaresAttribute("__eq__") and
  exists(ClassValue sup | sup = cls.getABaseType() and sup.declaredAttribute("__eq__") = base_eq |
    exists(SelfAttributeRead store | store.getName() = attrname |
      store.getScope() = base_eq.getScope()
    )
  )
}

from ClassValue cls, SelfAttributeStore store, Value base_eq
where
  class_stores_to_attribute(cls, store, _) and
  should_override_eq(cls, base_eq) and
  /* Don't report overridden unittest.TestCase. -- TestCase overrides __eq__, but subclasses do not really need to. */
  not cls.getASuperType().getName() = "TestCase" and
  not superclassEqExpectsAttribute(cls, base_eq, store.getName())
select cls,
  "The class '" + cls.getName() + "' does not override $@, but adds the new attribute $@.", base_eq,
  "'__eq__'", store, store.getName()
