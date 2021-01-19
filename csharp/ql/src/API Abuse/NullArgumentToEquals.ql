/**
 * @name Null argument to Equals(object)
 * @description Calls of the form 'o.Equals(null)' always return false for non-null 'o', and
 *              throw a 'NullReferenceException' when 'o' is null.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/null-argument-to-equals
 * @tags reliability
 *       correctness
 */

import csharp
import semmle.code.csharp.frameworks.System

from MethodCall c, EqualsMethod equals
where
  c.getTarget().getUnboundDeclaration() = equals and
  c.getArgument(0) instanceof NullLiteral and
  not c.getQualifier().getType() instanceof NullableType
select c, "Equality test with 'null' will never be true, but may throw a 'NullReferenceException'."
