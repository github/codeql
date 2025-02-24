/** Provides classes and predicates to reason about exposed actuators in Spring Boot. */

import java
private import semmle.code.java.frameworks.spring.SpringSecurity
private import semmle.code.java.frameworks.spring.SpringBoot

/**
 * A call to `HttpSecurity.requestMatcher` method with argument
 * `EndpointRequest.toAnyEndpoint()`.
 */
private class RequestMatcherCall extends MethodCall {
  RequestMatcherCall() {
    this.getMethod().hasName("requestMatcher") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity and
    this.getArgument(0) instanceof ToAnyEndpointCall
  }
}

/**
 * A call to `HttpSecurity.requestMatchers` method with lambda argument
 * `EndpointRequest.toAnyEndpoint()`.
 */
private class RequestMatchersCall extends MethodCall {
  RequestMatchersCall() {
    this.getMethod().hasName("requestMatchers") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity and
    this.getArgument(0).(LambdaExpr).getExprBody() instanceof ToAnyEndpointCall
  }
}

/**
 * A call to `AbstractRequestMatcherRegistry.requestMatchers` method with an argument
 * `RequestMatcher.toAnyEndpoint()`.
 */
private class RegistryRequestMatchersCall extends MethodCall {
  RegistryRequestMatchersCall() {
    this.getMethod().hasName("requestMatchers") and
    this.getMethod().getDeclaringType() instanceof TypeAbstractRequestMatcherRegistry and
    this.getAnArgument() instanceof ToAnyEndpointCall
  }
}

/**
 * A call to `HttpSecurity.securityMatcher` method with argument
 * `EndpointRequest.toAnyEndpoint()`.
 */
private class SecurityMatcherCall extends MethodCall {
  SecurityMatcherCall() {
    this.getMethod().hasName("securityMatcher") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity and
    this.getArgument(0) instanceof ToAnyEndpointCall
  }
}

/**
 * A call to `HttpSecurity.securityMatchers` method with lambda argument
 * `EndpointRequest.toAnyEndpoint()`.
 */
private class SecurityMatchersCall extends MethodCall {
  SecurityMatchersCall() {
    this.getMethod().hasName("securityMatchers") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity and
    this.getArgument(0).(LambdaExpr).getExprBody() instanceof ToAnyEndpointCall
  }
}

/**
 * A call to a method that authorizes requests, e.g. `authorizeRequests` or
 * `authorizeHttpRequests`.
 */
private class AuthorizeCall extends MethodCall {
  AuthorizeCall() {
    this instanceof AuthorizeRequestsCall or
    this instanceof AuthorizeHttpRequestsCall
  }
}

/**
 * A call to a matcher method with argument
 * `EndpointRequest.toAnyEndpoint()`.
 */
private class MatcherCall extends MethodCall {
  MatcherCall() {
    this instanceof RequestMatcherCall or
    this instanceof SecurityMatcherCall
  }
}

/**
 * A call to a matchers method with argument
 * `EndpointRequest.toAnyEndpoint()`.
 */
private class MatchersCall extends MethodCall {
  MatchersCall() {
    this instanceof RequestMatchersCall or
    this instanceof SecurityMatchersCall
  }
}

/** Holds if `permitAllCall` is called on request(s) mapped to actuator endpoint(s). */
predicate permitsSpringBootActuators(PermitAllCall permitAllCall) {
  exists(AuthorizeCall authorizeCall |
    // .requestMatcher(EndpointRequest).authorizeRequests([...]).[...]
    authorizeCall.getQualifier() instanceof MatcherCall
    or
    // .requestMatchers(matcher -> EndpointRequest).authorizeRequests([...]).[...]
    authorizeCall.getQualifier() instanceof MatchersCall
  |
    // [...].authorizeRequests(r -> r.anyRequest().permitAll()) or
    // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
    authorizeCall.getArgument(0).(LambdaExpr).getExprBody() = permitAllCall and
    (
      permitAllCall.getQualifier() instanceof AnyRequestCall or
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
    exists(AnyRequestCall anyRequestCall |
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
    exists(Variable v, MatcherCall matcherCall |
      // http.securityMatcher(EndpointRequest.toAnyEndpoint());
      // http.authorizeRequests([...].permitAll())
      v.getAnAccess() = authorizeCall.getQualifier() and
      v.getAnAccess() = matcherCall.getQualifier() and
      authorizeCall.getArgument(0).(LambdaExpr).getExprBody() = permitAllCall and
      permitAllCall.getQualifier() instanceof AnyRequestCall
    )
  )
}
