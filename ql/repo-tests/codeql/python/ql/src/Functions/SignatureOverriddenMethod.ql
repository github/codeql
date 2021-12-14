/**
 * @name Signature mismatch in overriding method
 * @description Overriding a method without ensuring that both methods accept the same
 *              number and type of parameters has the potential to cause an error when there is a mismatch.
 * @kind problem
 * @problem.severity warning
 * @tags reliability
 *       correctness
 * @sub-severity high
 * @precision very-high
 * @id py/inheritance/signature-mismatch
 */

import python
import Expressions.CallArgs

from FunctionValue base, PythonFunctionValue derived
where
  not exists(base.getACall()) and
  not exists(FunctionValue a_derived |
    a_derived.overrides(base) and
    exists(a_derived.getACall())
  ) and
  not derived.getScope().isSpecialMethod() and
  derived.getName() != "__init__" and
  derived.isNormalMethod() and
  // call to overrides distributed for efficiency
  (
    derived.overrides(base) and derived.minParameters() > base.maxParameters()
    or
    derived.overrides(base) and derived.maxParameters() < base.minParameters()
  )
select derived, "Overriding method '" + derived.getName() + "' has signature mismatch with $@.",
  base, "overridden method"
