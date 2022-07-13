/**
 * @name Creating an ASP.NET debug binary may reveal sensitive information
 * @description ASP.NET projects should not produce debug binaries when deploying to production as
 *              debug builds provide additional information useful to a malicious attacker.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision very-high
 * @id cs/web/debug-binary
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-11
 *       external/cwe/cwe-532
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebXmlElement web, XMLAttribute debugAttribute
where
  debugAttribute = web.getAChild("compilation").getAttribute("debug") and
  not debugAttribute.getValue().toLowerCase() = "false"
select debugAttribute, "The 'debug' flag is set for an ASP.NET configuration file."
