/**
 * @name Page request validation is disabled
 * @description ASP.NET pages should not disable the built-in request validation.
 * @kind problem
 * @problem.severity warning
 * @id cs/web/request-validation-disabled
 * @tags security
 *       frameworks/asp.net
 *       external/cwe/cwe-16
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebXMLElement web, XMLAttribute requestvalidateAttribute
where
  requestvalidateAttribute = web.getAChild("pages").getAttribute("validateRequest") and
  requestvalidateAttribute.getValue().toLowerCase() = "false"
select requestvalidateAttribute, "The 'validateRequest' attribute is set to 'false'."
