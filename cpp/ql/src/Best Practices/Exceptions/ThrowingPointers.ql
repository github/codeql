/**
 * @name Throwing pointers
 * @description Exceptions should be objects rather than pointers to objects.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/throwing-pointer
 * @tags efficiency
 *       correctness
 *       exceptions
 */

import cpp

from ThrowExpr throw, NewExpr new, Type t
where
  new.getParent() = throw and
  // Microsoft MFC's CException hierarchy should be thrown (and caught) as pointers
  t = new.getAllocatedType() and
  not t.getUnderlyingType().(Class).getABaseClass*().hasName("CException")
select throw, "This should throw a " + t.toString() + " rather than a pointer to one."
