/**
 * @name 'requireSSL' attribute is not set to true
 * @description Omitting the 'requireSSL' attribute allows data to be transmitted insecurely
 *              using HTTP. Always set 'requireSSL' to 'true' to ensure that HTTPS
 *              is used at all times.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/web/requiressl-not-set
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-614
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web

class FormsElement extends XMLElement {
  FormsElement() {
    this = any(SystemWebXMLElement sw).getAChild("authentication").getAChild("forms")
  }

  string getRequireSSL() { result = getAttribute("requireSSL").getValue().trim().toLowerCase() }

  predicate isRequireSSL() { getRequireSSL() = "true" }
}

class HttpCookiesElement extends XMLElement {
  HttpCookiesElement() { this = any(SystemWebXMLElement sw).getAChild("httpCookies") }

  string getRequireSSL() { result = getAttribute("requireSSL").getValue().trim().toLowerCase() }

  predicate isRequireSSL() {
    getRequireSSL() = "true"
    or
    not getRequireSSL() = "false" and
    exists(FormsElement forms | forms.getFile() = getFile() | forms.isRequireSSL())
  }
}

from XMLElement element
where
  element instanceof FormsElement and
  not element.(FormsElement).isRequireSSL()
  or
  element instanceof HttpCookiesElement and
  not element.(HttpCookiesElement).isRequireSSL() and
  not any(SystemWebHttpCookie c).getSecureProperty().getAnAssignedValue().getValue() = "true"
select element, "The 'requireSSL' attribute is not set to 'true'."
