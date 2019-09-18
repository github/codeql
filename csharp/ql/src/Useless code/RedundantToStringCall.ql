/**
 * @name Redundant ToString() call
 * @description Explicit calls to `ToString()` can be removed when the call
 *              appears in a context where an implicit conversion exists.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/useless-tostring-call
 * @tags maintainability
 *       useless-code
 */

import csharp
import semmle.code.csharp.commons.Strings
import semmle.code.csharp.frameworks.System

from MethodCall mc
where
  mc instanceof ImplicitToStringExpr and
  mc.getTarget() instanceof ToStringMethod
select mc, "Redundant call to 'ToString'."
