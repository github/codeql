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

/**
 * The class `org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest`.
 */
class TypeEndpointRequest extends Class {
  TypeEndpointRequest() {
    this.hasQualifiedName("org.springframework.boot.actuate.autoconfigure.security.servlet",
      "EndpointRequest")
  }
}

/** A call to `EndpointRequest.toAnyEndpoint` method. */
class ToAnyEndpointCall extends MethodAccess {
  ToAnyEndpointCall() {
    this.getMethod().hasName("toAnyEndpoint") and
    this.getMethod().getDeclaringType() instanceof TypeEndpointRequest
  }
}

/**
 * A call to `HttpSecurity.requestMatcher` method with argument `RequestMatcher.toAnyEndpoint()`.
 */
class RequestMatcherCall extends MethodAccess {
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
class RequestMatchersCall extends MethodAccess {
  RequestMatchersCall() {
    this.getMethod().hasName("requestMatchers") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity and
    this.getArgument(0).(LambdaExpr).getExprBody() instanceof ToAnyEndpointCall
  }
}

/** A call to `HttpSecurity.authorizeRequests` method. */
class AuthorizeRequestsCall extends MethodAccess {
  AuthorizeRequestsCall() {
    this.getMethod().hasName("authorizeRequests") and
    this.getMethod().getDeclaringType() instanceof TypeHttpSecurity
  }
}

/** A call to `AuthorizedUrl.permitAll` method. */
class PermitAllCall extends MethodAccess {
  PermitAllCall() {
    this.getMethod().hasName("permitAll") and
    this.getMethod().getDeclaringType() instanceof TypeAuthorizedUrl
  }

  /** Holds if `permitAll` is called on request(s) mapped to actuator endpoint(s). */
  predicate permitsSpringBootActuators() {
    exists(AuthorizeRequestsCall authorizeRequestsCall |
      // .requestMatcher(EndpointRequest).authorizeRequests([...]).[...]
      authorizeRequestsCall.getQualifier() instanceof RequestMatcherCall
      or
      // .requestMatchers(matcher -> EndpointRequest).authorizeRequests([...]).[...]
      authorizeRequestsCall.getQualifier() instanceof RequestMatchersCall
    |
      // [...].authorizeRequests(r -> r.anyRequest().permitAll()) or
      // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
      authorizeRequestsCall.getArgument(0).(LambdaExpr).getExprBody() = this and
      (
        this.getQualifier() instanceof AnyRequestCall or
        this.getQualifier() instanceof RegistryRequestMatchersCall
      )
      or
      // [...].authorizeRequests().requestMatchers(EndpointRequest).permitAll() or
      // [...].authorizeRequests().anyRequest().permitAll()
      authorizeRequestsCall.getNumArgument() = 0 and
      exists(RegistryRequestMatchersCall registryRequestMatchersCall |
        registryRequestMatchersCall.getQualifier() = authorizeRequestsCall and
        this.getQualifier() = registryRequestMatchersCall
      )
      or
      exists(AnyRequestCall anyRequestCall |
        anyRequestCall.getQualifier() = authorizeRequestsCall and
        this.getQualifier() = anyRequestCall
      )
    )
    or
    exists(AuthorizeRequestsCall authorizeRequestsCall |
      // http.authorizeRequests([...]).[...]
      authorizeRequestsCall.getQualifier() instanceof VarAccess
    |
      // [...].authorizeRequests(r -> r.requestMatchers(EndpointRequest).permitAll())
      authorizeRequestsCall.getArgument(0).(LambdaExpr).getExprBody() = this and
      this.getQualifier() instanceof RegistryRequestMatchersCall
      or
      // [...].authorizeRequests().requestMatchers(EndpointRequest).permitAll() or
      authorizeRequestsCall.getNumArgument() = 0 and
      exists(RegistryRequestMatchersCall registryRequestMatchersCall |
        registryRequestMatchersCall.getQualifier() = authorizeRequestsCall and
        this.getQualifier() = registryRequestMatchersCall
      )
    )
  }
}

/** A call to `AbstractRequestMatcherRegistry.anyRequest` method. */
class AnyRequestCall extends MethodAccess {
  AnyRequestCall() {
    this.getMethod().hasName("anyRequest") and
    this.getMethod().getDeclaringType() instanceof TypeAbstractRequestMatcherRegistry
  }
}

/**
 * A call to `AbstractRequestMatcherRegistry.requestMatchers` method with an argument
 * `RequestMatcher.toAnyEndpoint()`.
 */
class RegistryRequestMatchersCall extends MethodAccess {
  RegistryRequestMatchersCall() {
    this.getMethod().hasName("requestMatchers") and
    this.getMethod().getDeclaringType() instanceof TypeAbstractRequestMatcherRegistry and
    this.getAnArgument() instanceof ToAnyEndpointCall
  }
}
