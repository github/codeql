/**
 * @name Cookie security: overly broad domain
 * @description Finds cookies with an overly broad domain.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id cs/web/broad-cookie-domain
 * @tags security
 *       external/cwe/cwe-287
 */

import csharp

from Assignment a, PropertyAccess pa
where
  a.getLValue() = pa and
  pa.getTarget().hasName("Domain") and
  pa.getTarget().getDeclaringType().hasQualifiedName("System.Web", "HttpCookie") and
  (
    a.getRValue().getValue().regexpReplaceAll("[^.]", "").length() < 2 or
    a.getRValue().getValue().matches(".%")
  )
select a, "Overly broad domain for cookie."
