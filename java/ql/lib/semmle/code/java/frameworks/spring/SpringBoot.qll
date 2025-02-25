/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.boot.*`.
 */

import java

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
class ToAnyEndpointCall extends MethodCall {
  ToAnyEndpointCall() {
    this.getMethod().hasName("toAnyEndpoint") and
    this.getMethod().getDeclaringType() instanceof TypeEndpointRequest
  }
}
