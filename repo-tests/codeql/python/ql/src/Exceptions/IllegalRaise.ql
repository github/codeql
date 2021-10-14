/**
 * @name Illegal raise
 * @description Raising a non-exception object or type will result in a TypeError being raised instead.
 * @kind problem
 * @tags reliability
 *       correctness
 *       types
 * @problem.severity error
 * @sub-severity high
 * @precision very-high
 * @id py/illegal-raise
 */

import python
import Raising
import Exceptions.NotImplemented

from Raise r, ClassValue t
where
  type_or_typeof(r, t, _) and
  not t.isLegalExceptionType() and
  not t.failedInference(_) and
  not use_of_not_implemented_in_raise(r, _)
select r,
  "Illegal class '" + t.getName() + "' raised; will result in a TypeError being raised instead."
