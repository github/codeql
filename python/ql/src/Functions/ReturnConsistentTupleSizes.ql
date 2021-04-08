/**
 * @name Returning tuples with varying lengths
 * @description A function that potentially returns tuples of different lengths may indicate a problem.
 * @kind problem
 * @tags reliability
 *       maintainability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/mixed-tuple-returns
 */

import python

predicate returns_tuple_of_size(Function func, int size, AstNode origin) {
  exists(Return return, TupleValue val |
    return.getScope() = func and
    return.getValue().pointsTo(val, origin)
  |
    size = val.length()
  )
}

from Function func, int s1, int s2, AstNode t1, AstNode t2
where
  returns_tuple_of_size(func, s1, t1) and
  returns_tuple_of_size(func, s2, t2) and
  s1 < s2
select func, func.getQualifiedName() + " returns $@ and $@.", t1, "tuple of size " + s1, t2,
  "tuple of size " + s2
