/**
 * @name CORS misconfiguration
 * @description cors.allowed.origins is set to *, allowing a remote user to control which origins are trusted.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/tomcat-cors-origin-set
 * @tags security
 *       external/cwe/cwe-346
 */
import java
import semmle.code.xml.WebXML

private class Alloworigin extends WebContextParameter {
  Alloworigin() { this.getParamName().getValue() = "cors.allowed.origins" }

  string getParamValueElementValue() { result = getParamValue().getValue() }

  predicate isallowOriginSet() { getParamValueElementValue().toLowerCase() = "*" }
}
private class SupportsCredentials extends WebContextParameter {
  SupportsCredentials() { this.getParamName().getValue() = "cors.support.credentials" }

  string getParamValueElementValue() { result = getParamValue().getValue() }

  predicate isCredentialsSet() { getParamValueElementValue().toLowerCase() = "true" }
}

from Alloworigin origin , SupportsCredentials cred
where origin.isallowOriginSet() and cred.isCredentialsSet()
select origin,
  "CORS header is being set using user controlled value"
