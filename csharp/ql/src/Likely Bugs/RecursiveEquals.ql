/**
 * @name Recursive call to Equals(object)
 * @description A call to 'Equals(object)' is recursive: often this is due to a mistake in invoking a definition
 *              of 'Equals(...)' with a different signature.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/recursive-equals-call
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

from EqualsMethod caller, MethodCall call
where
  call.getEnclosingCallable() = caller and
  call.getTarget() = caller and
  (call.hasQualifier() implies call.hasThisQualifier()) and
  call.getArgument(0).stripCasts() = caller.getParameter(0).getAnAccess()
select call, "This call to 'Equals' is recursive: did you mean to cast the argument?"
