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
 * `org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer`.
 */
class TypeAuthorizedUrl extends Class {
  TypeAuthorizedUrl() {
    this.hasQualifiedName("org.springframework.security.config.annotation.web.configurers",
      "ExpressionUrlAuthorizationConfigurer<HttpSecurity>$AuthorizedUrl<>")
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

/** A call to `HttpSecurity.authorizeRequests` method. */
class AuthorizeRequestsCall extends MethodCall {
  AuthorizeRequestsCall() {
    this.getMethod().hasName("authorizeRequests") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/** A call to `AuthorizedUrl.permitAll` method. */
class PermitAllCall extends MethodCall {
  PermitAllCall() {
    this.getMethod().hasName("permitAll") and
    this.getMethod().getDeclaringType() instanceof TypeAuthorizedUrl
  }
}

/** A call to `AbstractRequestMatcherRegistry.anyRequest` method. */
class AnyRequestCall extends MethodCall {
  AnyRequestCall() {
    this.getMethod().hasName("anyRequest") and
    this.getMethod().getDeclaringType() instanceof TypeAbstractRequestMatcherRegistry
  }
}
