import java

/** The class `org.springframework.security.config.annotation.web.builders.HttpSecurity`. */
class TypeHttpSecurity extends Class {
  TypeHttpSecurity() {
    this
        .hasQualifiedName("org.springframework.security.config.annotation.web.builders",
          "HttpSecurity")
  }
}

/**
 * The class
 * `org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer`.
 */
class TypeAuthorizedUrl extends Class {
  TypeAuthorizedUrl() {
    this
        .hasQualifiedName("org.springframework.security.config.annotation.web.configurers",
          "ExpressionUrlAuthorizationConfigurer<HttpSecurity>$AuthorizedUrl<>")
  }
}

/**
 * The class
 * `org.springframework.security.config.annotation.web.AbstractRequestMatcherRegistry`.
 */
class TypeAbstractRequestMatcherRegistry extends Class {
  TypeAbstractRequestMatcherRegistry() {
    this
        .hasQualifiedName("org.springframework.security.config.annotation.web",
          "AbstractRequestMatcherRegistry<AuthorizedUrl<>>")
  }
}

/**
 * The class
 * `org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest.EndpointRequestMatcher`.
 */
class TypeEndpointRequestMatcher extends Class {
  TypeEndpointRequestMatcher() {
    this
        .hasQualifiedName("org.springframework.boot.actuate.autoconfigure.security.servlet",
          "EndpointRequest$EndpointRequestMatcher")
  }
}

/**
 * A call to `HttpSecurity.requestMatcher` method with argument of type
 * `EndpointRequestMatcher`.
 */
class RequestMatcherCall extends MethodAccess {
  RequestMatcherCall() {
    getMethod().hasName("requestMatcher") and
    getMethod().getDeclaringType() instanceof TypeHttpSecurity and
    getArgument(0).getType() instanceof TypeEndpointRequestMatcher
  }
}

/**
 * A call to `HttpSecurity.requestMatchers` method with lambda argument resolving to
 * `EndpointRequestMatcher` type.
 */
class RequestMatchersCall extends MethodAccess {
  RequestMatchersCall() {
    getMethod().hasName("requestMatchers") and
    getMethod().getDeclaringType() instanceof TypeHttpSecurity and
    getArgument(0).(LambdaExpr).getExprBody().getType() instanceof TypeEndpointRequestMatcher
  }
}

/** A call to `HttpSecurity.authorizeRequests` method. */
class AuthorizeRequestsCall extends MethodAccess {
  AuthorizeRequestsCall() {
    getMethod().hasName("authorizeRequests") and
    getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/** A call to `AuthorizedUrl.permitAll` method. */
class PermitAllCall extends MethodAccess {
  PermitAllCall() {
    getMethod().hasName("permitAll") and
    getMethod().getDeclaringType() instanceof TypeAuthorizedUrl
  }

  /** Holds if `permitAll` is called on request(s) mapped to actuator endpoint(s). */
  predicate permitsSpringBootActuators() {
    exists(
      RequestMatcherCall requestMatcherCall, RequestMatchersCall requestMatchersCall,
      RegistryRequestMatchersCall registryRequestMatchersCall,
      AuthorizeRequestsCall authorizeRequestsCall, AnyRequestCall anyRequestCall
    |
      // .requestMatcher(EndpointRequest).authorizeRequests([...]).[...]
      authorizeRequestsCall.getQualifier() = requestMatcherCall
      or
      // .requestMatchers(matcher -> EndpointRequest).authorizeRequests([...]).[...]
      authorizeRequestsCall.getQualifier() = requestMatchersCall
      or
      // http.authorizeRequests([...]).[...]
      authorizeRequestsCall.getQualifier() instanceof VarAccess
    |
      // [...].authorizeRequests(r -> r.anyRequest().permitAll()) or
      // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
      authorizeRequestsCall.getArgument(0).(LambdaExpr).getExprBody() = this and
      (
        this.getQualifier() = anyRequestCall or
        this.getQualifier() = registryRequestMatchersCall
      )
      or
      // [...].authorizeRequests().requestMatchers(EndpointRequest).permitAll() or
      // [...].authorizeRequests().anyRequest().permitAll()
      authorizeRequestsCall.getNumArgument() = 0 and
      (
        registryRequestMatchersCall.getQualifier() = authorizeRequestsCall and
        this.getQualifier() = registryRequestMatchersCall
      )
      or
      anyRequestCall.getQualifier() = authorizeRequestsCall and
      this.getQualifier() = anyRequestCall
    )
  }
}

/** A call to `AbstractRequestMatcherRegistry.anyRequest` method. */
class AnyRequestCall extends MethodAccess {
  AnyRequestCall() {
    getMethod().hasName("anyRequest") and
    getMethod().getDeclaringType() instanceof TypeAbstractRequestMatcherRegistry
  }
}

/**
 * A call to `AbstractRequestMatcherRegistry.requestMatchers` method with an argument of type
 * `EndpointRequestMatcher`.
 */
class RegistryRequestMatchersCall extends MethodAccess {
  RegistryRequestMatchersCall() {
    getMethod().hasName("requestMatchers") and
    getMethod().getDeclaringType() instanceof TypeAbstractRequestMatcherRegistry and
    getAnArgument().getType() instanceof TypeEndpointRequestMatcher
  }
}
