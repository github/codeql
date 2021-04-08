/**
 * @name Mutation of descriptor in __get__ or __set__ method.
 * @description Descriptor objects can be shared across many instances. Mutating them can cause strange side effects or race conditions.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/mutable-descriptor
 */

import python

predicate mutates_descriptor(ClassObject cls, SelfAttributeStore s) {
  cls.isDescriptorType() and
  exists(PyFunctionObject f, PyFunctionObject get_set |
    exists(string name | cls.lookupAttribute(name) = get_set |
      name = "__get__" or name = "__set__" or name = "__delete__"
    ) and
    cls.lookupAttribute(_) = f and
    get_set.getACallee*() = f and
    not f.getName() = "__init__" and
    s.getScope() = f.getFunction()
  )
}

from ClassObject cls, SelfAttributeStore s
where mutates_descriptor(cls, s)
select s,
  "Mutation of descriptor $@ object may lead to action-at-a-distance effects or race conditions for properties.",
  cls, cls.getName()
