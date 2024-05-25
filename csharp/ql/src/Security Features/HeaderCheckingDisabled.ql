/**
 * @name Header checking disabled
 * @description Finds places where header checking is disabled.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id cs/web/disabled-header-checking
 * @tags security
 *       external/cwe/cwe-113
 */

import csharp
import semmle.code.asp.WebConfig

from Element l
where
  // header checking is disabled programmatically in the code
  exists(Assignment a, PropertyAccess pa |
    a.getLValue() = pa and
    pa.getTarget().hasName("EnableHeaderChecking") and
    pa.getTarget()
        .getDeclaringType()
        .hasFullyQualifiedName("System.Web.Configuration", "HttpRuntimeSection") and
    a.getRValue().getValue() = "false" and
    a = l
  )
  or
  // header checking is disabled in a configuration file
  exists(HttpRuntimeXmlElement e, XmlAttribute a |
    a = e.getAttribute("enableHeaderChecking") and
    a.getValue().toLowerCase() = "false" and
    a = l
  )
select l, "Do not disable header checking."
