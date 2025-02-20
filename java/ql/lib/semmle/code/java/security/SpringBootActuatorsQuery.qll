/** Provides classes and predicates to reason about exposed actuators in Spring Boot. */

import java
private import semmle.code.java.frameworks.spring.SpringSecurity
private import semmle.code.java.frameworks.spring.SpringBoot

/**
 * A call to `HttpSecurity.requestMatcher` method with argument
 * `RequestMatcher.toAnyEndpoint()`.
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
 * `RequestMatcher.toAnyEndpoint()`.
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

/** Holds if `permitAllCall` is called on request(s) mapped to actuator endpoint(s). */
predicate permitsSpringBootActuators(PermitAllCall permitAllCall) {
  exists(AuthorizeRequestsCall authorizeRequestsCall |
    // .requestMatcher(EndpointRequest).authorizeRequests([...]).[...]
    authorizeRequestsCall.getQualifier() instanceof RequestMatcherCall
    or
    // .requestMatchers(matcher -> EndpointRequest).authorizeRequests([...]).[...]
    authorizeRequestsCall.getQualifier() instanceof RequestMatchersCall
  |
    // [...].authorizeRequests(r -> r.anyRequest().permitAll()) or
    // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
    authorizeRequestsCall.getArgument(0).(LambdaExpr).getExprBody() = permitAllCall and
    (
      permitAllCall.getQualifier() instanceof AnyRequestCall or
      permitAllCall.getQualifier() instanceof RegistryRequestMatchersCall
    )
    or
    // [...].authorizeRequests().requestMatchers(EndpointRequest).permitAll() or
    // [...].authorizeRequests().anyRequest().permitAll()
    authorizeRequestsCall.getNumArgument() = 0 and
    exists(RegistryRequestMatchersCall registryRequestMatchersCall |
      registryRequestMatchersCall.getQualifier() = authorizeRequestsCall and
      permitAllCall.getQualifier() = registryRequestMatchersCall
    )
    or
    exists(AnyRequestCall anyRequestCall |
      anyRequestCall.getQualifier() = authorizeRequestsCall and
      permitAllCall.getQualifier() = anyRequestCall
    )
  )
  or
  exists(AuthorizeRequestsCall authorizeRequestsCall |
    // http.authorizeRequests([...]).[...]
    authorizeRequestsCall.getQualifier() instanceof VarAccess
  |
    // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
    authorizeRequestsCall.getArgument(0).(LambdaExpr).getExprBody() = permitAllCall and
    permitAllCall.getQualifier() instanceof RegistryRequestMatchersCall
    or
    // [...].authorizeRequests().requestMatchers(EndpointRequest).permitAll() or
    authorizeRequestsCall.getNumArgument() = 0 and
    exists(RegistryRequestMatchersCall registryRequestMatchersCall |
      registryRequestMatchersCall.getQualifier() = authorizeRequestsCall and
      permitAllCall.getQualifier() = registryRequestMatchersCall
    )
  )
}
