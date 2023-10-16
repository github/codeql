/** Provides predicates to reason about disabling CSRF protection in Spring. */

import java

/** Holds if `call` disables CSRF protection in Spring. */
predicate disablesSpringCsrfProtection(MethodAccess call) {
  call.getMethod().hasName("disable") and
  call.getReceiverType()
      .hasQualifiedName("org.springframework.security.config.annotation.web.configurers",
        "CsrfConfigurer<HttpSecurity>")
  or
  call.getMethod()
      .hasQualifiedName("org.springframework.security.config.annotation.web.builders",
        "HttpSecurity", "csrf") and
  call.getArgument(0)
      .(MemberRefExpr)
      .getReferencedCallable()
      .hasQualifiedName("org.springframework.security.config.annotation.web.configurers",
        "AbstractHttpConfigurer", "disable")
}
