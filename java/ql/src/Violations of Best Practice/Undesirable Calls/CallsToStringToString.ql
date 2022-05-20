/**
 * @name Useless toString on String
 * @description Calling 'toString' on a string is redundant.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/useless-tostring-call
 * @tags maintainability
 */

import java

from MethodAccess ma, ToStringMethod tostring
where
  tostring.getDeclaringType() instanceof TypeString and
  ma.getMethod() = tostring
select ma, "Redundant call to 'toString' on a String object."
