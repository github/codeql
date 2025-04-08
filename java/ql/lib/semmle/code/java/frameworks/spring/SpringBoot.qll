/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.boot.*`.
 */

import java

/**
 * The class `org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest`.
 */
class SpringEndpointRequest extends Class {
  SpringEndpointRequest() {
    this.hasQualifiedName("org.springframework.boot.actuate.autoconfigure.security.servlet",
      "EndpointRequest")
  }
}

/** A call to `EndpointRequest.toAnyEndpoint` method. */
class SpringToAnyEndpointCall extends MethodCall {
  SpringToAnyEndpointCall() {
    this.getMethod().hasName("toAnyEndpoint") and
    this.getMethod().getDeclaringType() instanceof SpringEndpointRequest
  }
}
