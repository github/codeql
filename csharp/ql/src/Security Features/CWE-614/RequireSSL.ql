/**
 * @name 'requireSSL' attribute is not set to true
 * @description Omitting the 'requireSSL' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'requireSSL' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/web/requiressl-not-set
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web

// the query is a subset of `cs/web/cookie-secure-not-set` and
// should be removed once it is promoted from experimental
from XMLElement element
where
  element instanceof FormsElement and
  not element.(FormsElement).isRequireSSL()
  or
  element instanceof HttpCookiesElement and
  not element.(HttpCookiesElement).isRequireSSL() and
  not any(SystemWebHttpCookie c).getSecureProperty().getAnAssignedValue().getValue() = "true"
select element, "The 'requireSSL' attribute is not set to 'true'."
