/**
 * @name Page request validation is disabled
 * @description ASP.NET pages should not disable the built-in request validation.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @security-severity 7.5
 * @id cs/web/request-validation-disabled
 * @tags security
 *       frameworks/asp.net
 *       external/cwe/cwe-16
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebXmlElement web, XmlAttribute requestvalidateAttribute
where
  requestvalidateAttribute = web.getAChild("pages").getAttribute("validateRequest") and
  requestvalidateAttribute.getValue().toLowerCase() = "false"
select requestvalidateAttribute, "The 'validateRequest' attribute is set to 'false'."
