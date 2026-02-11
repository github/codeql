/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.security.*`.
 */
overlay[local?]
module;

import java

/** The class `org.springframework.security.config.annotation.web.builders.HttpSecurity`. */
class SpringHttpSecurity extends Class {
  SpringHttpSecurity() {
    this.hasQualifiedName("org.springframework.security.config.annotation.web.builders",
      "HttpSecurity")
  }
}

/**
 * The class
 * `org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer$AuthorizedUrl`
 * or the class
 * `org.springframework.security.config.annotation.web.configurers.AuthorizeHttpRequestsConfigurer$AuthorizedUrl`.
 */
class SpringAuthorizedUrl extends Class {
  SpringAuthorizedUrl() {
    this.hasQualifiedName("org.springframework.security.config.annotation.web.configurers",
      [
        "ExpressionUrlAuthorizationConfigurer<HttpSecurity>$AuthorizedUrl<>",
        "AuthorizeHttpRequestsConfigurer<HttpSecurity>$AuthorizedUrl<>"
      ])
  }
}

/**
 * The class `org.springframework.security.config.annotation.web.AbstractRequestMatcherRegistry`.
 */
class SpringAbstractRequestMatcherRegistry extends Class {
  SpringAbstractRequestMatcherRegistry() {
    this.hasQualifiedName("org.springframework.security.config.annotation.web",
      "AbstractRequestMatcherRegistry<AuthorizedUrl<>>")
  }
}

/**
 * A call to the `HttpSecurity.authorizeRequests` method.
 *
 * Note: this method is deprecated and scheduled for removal
 * in Spring Security 7.0.
 */
class SpringAuthorizeRequestsCall extends MethodCall {
  SpringAuthorizeRequestsCall() {
    this.getMethod().hasName("authorizeRequests") and
    this.getMethod().getDeclaringType() instanceof SpringHttpSecurity
  }
}

/**
 * A call to the `HttpSecurity.authorizeHttpRequests` method.
 *
 * Note: the no-argument version of this method is deprecated
 * and scheduled for removal in Spring Security 7.0.
 */
class SpringAuthorizeHttpRequestsCall extends MethodCall {
  SpringAuthorizeHttpRequestsCall() {
    this.getMethod().hasName("authorizeHttpRequests") and
    this.getMethod().getDeclaringType() instanceof SpringHttpSecurity
  }
}

/**
 * A call to the `HttpSecurity.requestMatcher` method.
 *
 * Note: this method was removed in Spring Security 6.0.
 * It was replaced by `securityMatcher`.
 */
class SpringRequestMatcherCall extends MethodCall {
  SpringRequestMatcherCall() {
    this.getMethod().hasName("requestMatcher") and
    this.getMethod().getDeclaringType() instanceof SpringHttpSecurity
  }
}

/**
 * A call to the `HttpSecurity.requestMatchers` method.
 *
 * Note: this method was removed in Spring Security 6.0.
 * It was replaced by `securityMatchers`.
 */
class SpringRequestMatchersCall extends MethodCall {
  SpringRequestMatchersCall() {
    this.getMethod().hasName("requestMatchers") and
    this.getMethod().getDeclaringType() instanceof SpringHttpSecurity
  }
}

/** A call to the `HttpSecurity.securityMatcher` method. */
class SpringSecurityMatcherCall extends MethodCall {
  SpringSecurityMatcherCall() {
    this.getMethod().hasName("securityMatcher") and
    this.getMethod().getDeclaringType() instanceof SpringHttpSecurity
  }
}

/** A call to the `HttpSecurity.securityMatchers` method. */
class SpringSecurityMatchersCall extends MethodCall {
  SpringSecurityMatchersCall() {
    this.getMethod().hasName("securityMatchers") and
    this.getMethod().getDeclaringType() instanceof SpringHttpSecurity
  }
}

/** A call to the `AuthorizedUrl.permitAll` method. */
class SpringPermitAllCall extends MethodCall {
  SpringPermitAllCall() {
    this.getMethod().hasName("permitAll") and
    this.getMethod().getDeclaringType() instanceof SpringAuthorizedUrl
  }
}

/** A call to the `AbstractRequestMatcherRegistry.anyRequest` method. */
class SpringAnyRequestCall extends MethodCall {
  SpringAnyRequestCall() {
    this.getMethod().hasName("anyRequest") and
    this.getMethod().getDeclaringType() instanceof SpringAbstractRequestMatcherRegistry
  }
}
