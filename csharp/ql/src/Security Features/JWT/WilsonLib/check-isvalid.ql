/**
 * @name JsonWebTokenHandler.ValidateToken return value is not checked
 * @description `JsonWebTokenHandler.ValidateToken` does not throw an exception if the return value is not valid.
 *   This query checks if the returning object `TokenValidationResult` is not accessing either the `IsValid` property or is accessing `Exception` property.
 * @kind problem
 * @tags security
 *       wilson-library
 *       manual-verification-required
 * @id cs/wilson-library/check-isvalid
 * @problem.severity warning
 * @precision high
 */

import csharp
import wilsonlib

from JsonWebTokenHandlerValidateTokenCall call
where
  not hasAFlowToTokenValidationResultIsValidCall(call) and
  not call.getEnclosingCallable() instanceof JsonWebTokenHandlerValidateTokenMethod
select call,
  "The call to $@ does not throw an exception if the resulting `TokenValidationResult` object is not valid, and the code in $@ is not checking the `IsValid` property or the `Exception` property to verify.",
  call, "`JsonWebTokenHandler.ValidateToken`", call.getEnclosingCallable(),
  getFullyQualifiedName(call.getEnclosingCallable())
