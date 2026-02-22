/**
 * @name Inconsistent method resolution order
 * @description Class definition will raise a type error at runtime due to inconsistent method resolution order(MRO)
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision very-high
 * @id py/inconsistent-mro
 */

import python
private import semmle.python.dataflow.new.internal.DataFlowDispatch

/**
 * Gets the `i`th base class of `cls`, if it can be resolved to a user-defined class.
 */
Class getBaseType(Class cls, int i) { cls.getBase(i) = classTracker(result).asExpr() }

Class left_base(Class type, Class base) {
  exists(int i | i > 0 and getBaseType(type, i) = base and result = getBaseType(type, i - 1))
}

predicate invalid_mro(Class t, Class left, Class right) {
  DuckTyping::isNewStyle(t) and
  left = left_base(t, right) and
  left = getADirectSuperclass*(right)
}

from Class t, Class left, Class right
where invalid_mro(t, left, right)
select t,
  "Construction of class " + t.getName() +
    " can fail due to invalid method resolution order(MRO) for bases $@ and $@.", left,
  left.getName(), right, right.getName()
