/**
 * @name Inconsistent equality and inequality
 * @description Class definitions of equality and inequality operators may be inconsistent.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/inconsistent-equality
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
import Classes.Equality

predicate missingEquality(Class cls, Function defined, string missing) {
  defined = cls.getMethod("__ne__") and
  not exists(cls.getMethod("__eq__")) and
  missing = "__eq__"
  or
  // In python 3, __ne__ automatically delegates to __eq__ if its not defined in the hierarchy
  // However if it is defined in a superclass (and isn't a delegation method) then it will use the superclass method (which may be incorrect)
  defined = cls.getMethod("__eq__") and
  not exists(cls.getMethod("__ne__")) and
  exists(Function neMeth |
    neMeth = getADirectSuperclass+(cls).getMethod("__ne__") and
    not neMeth instanceof DelegatingEqualityMethod
  ) and
  missing = "__ne__"
}

from Class cls, Function defined, string missing
where missingEquality(cls, defined, missing)
select cls, "This class implements $@, but does not implement " + missing + ".", defined,
  defined.getName()
