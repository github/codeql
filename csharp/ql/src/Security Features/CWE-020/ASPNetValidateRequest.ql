/**
 * @name Page Request validation is disabled.
 * @description ASP.NET Pages should not disable the built-in request validation.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/web/debug-binary
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-20
 */

import csharp
from XMLAttribute a
where
  a.getName().toLowerCase() = "validaterequest" and a.getValue() = "false"
select a, "ValidateRequest is set to false."
