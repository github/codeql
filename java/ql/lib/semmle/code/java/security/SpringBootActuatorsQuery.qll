/** Provides classes and predicates to reason about exposed actuators in Spring Boot. */

import java
private import semmle.code.java.frameworks.spring.SpringSecurity
private import semmle.code.java.frameworks.spring.SpringBoot

/**
 * A call to an `HttpSecurity` matcher method with argument
 * `EndpointRequest.toAnyEndpoint()`.
 */
private class HttpSecurityMatcherCall extends MethodCall {
  HttpSecurityMatcherCall() {
    (
      this instanceof SpringRequestMatcherCall or
      this instanceof SpringSecurityMatcherCall
    ) and
    this.getArgument(0) instanceof SpringToAnyEndpointCall
  }
}

/**
 * A call to an `HttpSecurity` matchers method with lambda
 * argument `EndpointRequest.toAnyEndpoint()`.
 */
private class HttpSecurityMatchersCall extends MethodCall {
  HttpSecurityMatchersCall() {
    (
      this instanceof SpringRequestMatchersCall or
      this instanceof SpringSecurityMatchersCall
    ) and
    this.getArgument(0).(LambdaExpr).getExprBody() instanceof SpringToAnyEndpointCall
  }
}

/**
 * A call to an `AbstractRequestMatcherRegistry.requestMatchers` method with
 * argument `EndpointRequest.toAnyEndpoint()`.
 */
private class RegistryRequestMatchersCall extends MethodCall {
  RegistryRequestMatchersCall() {
    this.getMethod().hasName("requestMatchers") and
    this.getMethod().getDeclaringType() instanceof SpringAbstractRequestMatcherRegistry and
    this.getAnArgument() instanceof SpringToAnyEndpointCall
  }
}

/** A call to an `HttpSecurity` method that authorizes requests. */
private class AuthorizeCall extends MethodCall {
  AuthorizeCall() {
    this instanceof SpringAuthorizeRequestsCall or
    this instanceof SpringAuthorizeHttpRequestsCall
  }
}

/** Holds if `permitAllCall` is called on request(s) mapped to actuator endpoint(s). */
predicate permitsSpringBootActuators(SpringPermitAllCall permitAllCall) {
  exists(AuthorizeCall authorizeCall |
    // .requestMatcher(EndpointRequest).authorizeRequests([...]).[...]
    authorizeCall.getQualifier() instanceof HttpSecurityMatcherCall
    or
    // .requestMatchers(matcher -> EndpointRequest).authorizeRequests([...]).[...]
    authorizeCall.getQualifier() instanceof HttpSecurityMatchersCall
  |
    // [...].authorizeRequests(r -> r.anyRequest().permitAll()) or
    // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
    authorizeCall.getArgument(0).(LambdaExpr).getExprBody() = permitAllCall and
    (
      permitAllCall.getQualifier() instanceof SpringAnyRequestCall or
      permitAllCall.getQualifier() instanceof RegistryRequestMatchersCall
    )
    or
    // [...].authorizeRequests().requestMatchers(EndpointRequest).permitAll() or
    // [...].authorizeRequests().anyRequest().permitAll()
    authorizeCall.getNumArgument() = 0 and
    exists(RegistryRequestMatchersCall registryRequestMatchersCall |
      registryRequestMatchersCall.getQualifier() = authorizeCall and
      permitAllCall.getQualifier() = registryRequestMatchersCall
    )
    or
    exists(SpringAnyRequestCall anyRequestCall |
      anyRequestCall.getQualifier() = authorizeCall and
      permitAllCall.getQualifier() = anyRequestCall
    )
  )
  or
  exists(AuthorizeCall authorizeCall |
    // http.authorizeRequests([...]).[...]
    authorizeCall.getQualifier() instanceof VarAccess
  |
    // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
    authorizeCall.getArgument(0).(LambdaExpr).getExprBody() = permitAllCall and
    permitAllCall.getQualifier() instanceof RegistryRequestMatchersCall
    or
    // [...].authorizeRequests().requestMatchers(EndpointRequest).permitAll() or
    authorizeCall.getNumArgument() = 0 and
    exists(RegistryRequestMatchersCall registryRequestMatchersCall |
      registryRequestMatchersCall.getQualifier() = authorizeCall and
      permitAllCall.getQualifier() = registryRequestMatchersCall
    )
    or
    exists(Variable v, HttpSecurityMatcherCall matcherCall |
      // http.securityMatcher(EndpointRequest.toAnyEndpoint());
      // http.authorizeRequests([...].permitAll())
      v.getAnAccess() = authorizeCall.getQualifier() and
      v.getAnAccess() = matcherCall.getQualifier() and
      authorizeCall.getArgument(0).(LambdaExpr).getExprBody() = permitAllCall and
      permitAllCall.getQualifier() instanceof SpringAnyRequestCall
    )
  )
}
