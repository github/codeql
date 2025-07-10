/**
 * @name Returning tuples with varying lengths
 * @description A function that potentially returns tuples of different lengths may indicate a problem.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/mixed-tuple-returns
 */

import python
import semmle.python.ApiGraphs

predicate returns_tuple_of_size(Function func, int size, Tuple tuple) {
  exists(Return return, DataFlow::Node value |
    value.asExpr() = return.getValue() and
    return.getScope() = func and
    any(DataFlow::LocalSourceNode n | n.asExpr() = tuple).flowsTo(value)
  |
    size = count(int n | exists(tuple.getElt(n)))
  )
}

from Function func, int s1, int s2, AstNode t1, AstNode t2
where
  returns_tuple_of_size(func, s1, t1) and
  returns_tuple_of_size(func, s2, t2) and
  s1 < s2 and
  // Don't report on functions that have a return type annotation
  not exists(func.getDefinition().(FunctionExpr).getReturns())
select func, func.getQualifiedName() + " returns $@ and $@.", t1, "tuple of size " + s1, t2,
  "tuple of size " + s2
