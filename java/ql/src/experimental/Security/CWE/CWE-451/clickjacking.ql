/**
 * @name Missing X-Frame-Options HTTP header
 * @description If the 'X-Frame-Options' setting is not provided, a malicious user may be able to
 *              overlay their own UI on top of the site by using an iframe.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/clickjacking
 * @tags security
 *       external/cwe/cwe-451
 */

import java
import semmle.code.java.frameworks.Servlets

private predicate hasCodeXFrameOptions(MethodAccess header) {
  (
    header.getMethod() instanceof ResponseSetHeaderMethod or
    header.getMethod() instanceof ResponseAddHeaderMethod
  ) and
  header.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "x-frame-options" 
}

from MethodAccess call
where not hasCodeXFrameOptions(call) 
select call, "Misconfigured X-Frame-Options Header."
