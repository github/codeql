/**
 * @name Disabled Spring CSRF protection
 * @description Disabling CSRF protection makes the application vulnerable to
 *              a Cross-Site Request Forgery (CSRF) attack.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/spring-disabled-csrf-protection
 * @tags security
 *       external/cwe/cwe-352
 */

import java

from MethodAccess call
where
  call.getMethod().hasName("disable") and
  call
      .getReceiverType()
      .hasQualifiedName("org.springframework.security.config.annotation.web.configurers",
        "CsrfConfigurer<HttpSecurity>")
select call, "CSRF vulnerability due to protection being disabled."
