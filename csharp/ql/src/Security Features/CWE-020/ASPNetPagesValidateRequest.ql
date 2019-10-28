/**
 * @name Page Request Validation is disabled
 * @description ASP.NET Pages should not disable the built-in request validation.
 * @kind problem
 * @problem.severity warning
 * @id cs/web/validate-request
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-20
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebXMLElement web, XMLAttribute requestvalidateAttribute
where
  requestvalidateAttribute = web.getAChild("pages").getAttribute("validateRequest") and
  requestvalidateAttribute.getValue().toLowerCase() = "false"
select requestvalidateAttribute, "ValidateRequest is set to false."
