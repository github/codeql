/**
 * @name Disabled Spring CSRF protection
 * @description Disabling CSRF protection makes the application vulnerable to
 *              a Cross-Site Request Forgery (CSRF) attack.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id java/spring-disabled-csrf-protection
 * @tags security
 *       external/cwe/cwe-352
 */

import java
import semmle.code.java.security.SpringCsrfProtection

from MethodCall call
where disablesSpringCsrfProtection(call)
select call, "CSRF vulnerability due to protection being disabled."
