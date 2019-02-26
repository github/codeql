/**
 * @name Large object passed by value
 * @description An object larger than 64 bytes is passed by value to a function. Passing large objects by value unnecessarily use up scarce stack space, increase the cost of calling a function and can be a security risk. Use a const pointer to the object instead.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id cpp/large-parameter
 * @tags efficiency
 *       readability
 *       statistical
 *       non-attributable
 */
import cpp

from Function f, Parameter p, Type t, int size
where f.getAParameter() = p
  and p.getType() = t
  and t.getSize() = size
  and size > 64
  and not t.getUnderlyingType() instanceof ArrayType
  and not f instanceof CopyAssignmentOperator
select
  p, "This parameter of type $@ is " + size.toString() + " bytes - consider passing a const pointer/reference instead.",
  t, t.toString()
