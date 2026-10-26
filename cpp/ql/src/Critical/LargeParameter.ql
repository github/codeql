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
import semmle.code.cpp.dataflow.EscapesTree

from Function f, Parameter p, Type t, int size
where
  f.getAParameter() = p and
  p.getType() = t and
  t.getSize() = size and
  size > 64 and
  not t.getUnderlyingType() instanceof ArrayType and
  not f instanceof CopyAssignmentOperator and
  // exception: p is written to, which may mean the copy is intended
  not p.getAnAccess().isAddressOfAccessNonConst() and
  not exists(Expr e |
    variableAccessedAsValue(p.getAnAccess(), e.getFullyConverted()) and
    (
      exists(Assignment an | an.getLValue() = e)
      or
      exists(CrementOperation co | co.getOperand() = e)
      or
      exists(FunctionCall fc | fc.getQualifier() = e and not fc.getTarget().hasSpecifier("const"))
    )
  ) and
  // if there's no block, we can't tell how the parameter is used
  exists(f.getBlock())
select p,
  "This parameter of type $@ is " + size.toString() +
    " bytes - consider passing a const pointer/reference instead.", t, t.toString()
