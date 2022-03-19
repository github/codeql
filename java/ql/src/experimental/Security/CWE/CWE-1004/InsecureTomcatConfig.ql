/**
 * @name Tomcat config disables 'HttpOnly' flag (XSS risk)
 * @description Disabling 'HttpOnly' leaves session cookies vulnerable to an XSS attack.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/tomcat-disabled-httponly
 * @tags security
 *       external/cwe/cwe-1004
 */

import java
import semmle.code.xml.WebXML

private class HttpOnlyConfig extends WebContextParameter {
  HttpOnlyConfig() { this.getParamName().getValue() = "useHttpOnly" }

  string getParamValueElementValue() { result = this.getParamValue().getValue() }

  predicate isHttpOnlySet() { this.getParamValueElementValue().toLowerCase() = "false" }
}

from HttpOnlyConfig config
where config.isHttpOnlySet()
select config,
  "httpOnly should be enabled in tomcat config file to help mitigate cross-site scripting (XSS) attacks"
