/**
 * @name ASP.NET config file enables directory browsing
 * @description Directory browsing should not be enabled in production as it can leak sensitive information.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision very-high
 * @id cs/web/directory-browse-enabled
 * @tags security
 *       external/cwe/cwe-548
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebServerXmlElement ws, XMLAttribute a
where
  ws.getAChild("directoryBrowse").getAttribute("enabled") = a and
  a.getValue() = "true"
select a, "Directory browsing is enabled in this ASP.NET configuration file."
