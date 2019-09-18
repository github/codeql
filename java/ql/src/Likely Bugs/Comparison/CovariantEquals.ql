/**
 * @name Overloaded equals
 * @description Defining 'Object.equals', where the parameter of 'equals' is not of the
 *              appropriate type, overloads 'equals' instead of overriding it.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/wrong-equals-signature
 * @tags reliability
 *       correctness
 */

import java

from RefType t, Method equals
where
  t.fromSource() and
  equals = t.getAMethod() and
  equals.hasName("equals") and
  equals.getNumberOfParameters() = 1 and
  not t.getAMethod() instanceof EqualsMethod
select equals, "To override the equals method, the parameter must be of type java.lang.Object."
