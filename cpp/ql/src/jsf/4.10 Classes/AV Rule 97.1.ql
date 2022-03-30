/**
 * @name AV Rule 97.1
 * @description Neither operand of an equality operator (== or !=) shall be a pointer to a virtual member function.
 * @kind problem
 * @id cpp/jsf/av-rule-97-1
 * @problem.severity error
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

from EqualityOperation e, PointerToMemberType t, Class c
where
  e.getAnOperand().getType() = t and
  t.getClass() = c and
  c.getAMemberFunction() instanceof VirtualFunction
select e,
  "AV Rule 97.1: Neither operand of an equality operator shall be a pointer to a virtual member function."
