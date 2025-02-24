/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.security.*`.
 */

import java

/** The class `org.springframework.security.config.annotation.web.builders.HttpSecurity`. */
class TypeHttpSecurity extends Class {
  TypeHttpSecurity() {
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
class TypeAuthorizedUrl extends Class {
  TypeAuthorizedUrl() {
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
class TypeAbstractRequestMatcherRegistry extends Class {
  TypeAbstractRequestMatcherRegistry() {
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
class AuthorizeRequestsCall extends MethodCall {
  AuthorizeRequestsCall() {
    this.getMethod().hasName("authorizeRequests") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/**
 * A call to the `HttpSecurity.authorizeHttpRequests` method.
 *
 * Note: the no-argument version of this method is deprecated
 * and scheduled for removal in Spring Security 7.0.
 */
class AuthorizeHttpRequestsCall extends MethodCall {
  AuthorizeHttpRequestsCall() {
    this.getMethod().hasName("authorizeHttpRequests") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/**
 * A call to the `HttpSecurity.requestMatcher` method.
 *
 * Note: this method was removed in Spring Security 6.0.
 * It was replaced by `securityMatcher`.
 */
class RequestMatcherCall extends MethodCall {
  RequestMatcherCall() {
    this.getMethod().hasName("requestMatcher") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/**
 * A call to the `HttpSecurity.requestMatchers` method.
 *
 * Note: this method was removed in Spring Security 6.0.
 * It was replaced by `securityMatchers`.
 */
class RequestMatchersCall extends MethodCall {
  RequestMatchersCall() {
    this.getMethod().hasName("requestMatchers") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/** A call to the `HttpSecurity.securityMatcher` method. */
class SecurityMatcherCall extends MethodCall {
  SecurityMatcherCall() {
    this.getMethod().hasName("securityMatcher") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/** A call to the `HttpSecurity.securityMatchers` method. */
class SecurityMatchersCall extends MethodCall {
  SecurityMatchersCall() {
    this.getMethod().hasName("securityMatchers") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/** A call to the `AuthorizedUrl.permitAll` method. */
class PermitAllCall extends MethodCall {
  PermitAllCall() {
    this.getMethod().hasName("permitAll") and
    this.getMethod().getDeclaringType() instanceof TypeAuthorizedUrl
  }
}

/** A call to the `AbstractRequestMatcherRegistry.anyRequest` method. */
class AnyRequestCall extends MethodCall {
  AnyRequestCall() {
    this.getMethod().hasName("anyRequest") and
    this.getMethod().getDeclaringType() instanceof TypeAbstractRequestMatcherRegistry
  }
}
