/**
 * @name Cookie security: overly broad path
 * @description Finds cookies with an overly broad path.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id cs/web/broad-cookie-path
 * @tags security
 *       external/cwe/cwe-287
 */

import csharp

from Assignment a, PropertyAccess pa
where
  a.getLValue() = pa and
  pa.getTarget().hasName("Path") and
  pa.getTarget().getDeclaringType().hasQualifiedName("System.Web", "HttpCookie") and
  a.getRValue().getValue() = "/"
select a, "Overly broad path for cookie."
