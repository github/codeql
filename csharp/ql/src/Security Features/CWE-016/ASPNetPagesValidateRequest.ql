/**
 * @name Page Request Validation is disabled
 * @description ASP.NET Pages should not disable the built-in request validation.
 * @kind problem
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebXMLElement web, XMLAttribute requestvalidateAttribute
where
  requestvalidateAttribute = web.getAChild("pages").getAttribute("validateRequest") and
  requestvalidateAttribute.getValue().toLowerCase() = "false"
select requestvalidateAttribute, "validateRequest is set to false"
