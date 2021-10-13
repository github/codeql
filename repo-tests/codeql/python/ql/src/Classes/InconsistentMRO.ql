/**
 * @name Inconsistent method resolution order
 * @description Class definition will raise a type error at runtime due to inconsistent method resolution order(MRO)
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision very-high
 * @id py/inconsistent-mro
 */

import python

ClassObject left_base(ClassObject type, ClassObject base) {
  exists(int i | i > 0 and type.getBaseType(i) = base and result = type.getBaseType(i - 1))
}

predicate invalid_mro(ClassObject t, ClassObject left, ClassObject right) {
  t.isNewStyle() and
  left = left_base(t, right) and
  left = right.getAnImproperSuperType()
}

from ClassObject t, ClassObject left, ClassObject right
where invalid_mro(t, left, right)
select t,
  "Construction of class " + t.getName() +
    " can fail due to invalid method resolution order(MRO) for bases $@ and $@.", left,
  left.getName(), right, right.getName()
