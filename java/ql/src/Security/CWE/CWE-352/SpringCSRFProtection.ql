/**
 * @name Disabled Spring CSRF protection
 * @description Disabling CSRF protection makes the application vulnerable to
 *              Cross-Site Request Forgery (CSRF) attack.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/spring-disabled-csrf-protection
 * @tags security
 *       external/cwe/cwe-352
 */

import java

from MethodAccess call, Method method
where
  call.getMethod() = method and
  method.hasName("disable") and
  method.getDeclaringType().getQualifiedName().regexpMatch(
    "org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer<CsrfConfigurer<.*>,.*>"
  )
select call, "CSRF vulnerability due to protection being disabled."
