/**
 * Provides classes for working with Spring web clients.
 */

import java
import SpringHttp

/** The class `org.springframework.web.client.RestTemplate`. */
class SpringRestTemplate extends Class {
  SpringRestTemplate() { this.hasQualifiedName("org.springframework.web.client", "RestTemplate") }
}

/**
 * A method declared in `org.springframework.web.client.RestTemplate` that
 * returns a `SpringResponseEntity`.
 */
class SpringRestTemplateResponseEntityMethod extends Method {
  SpringRestTemplateResponseEntityMethod() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.getReturnType() instanceof SpringResponseEntity
  }
}

/** The interface `org.springframework.web.reactive.function.client.WebClient`. */
class SpringWebClient extends Interface {
  SpringWebClient() {
    this.hasQualifiedName("org.springframework.web.reactive.function.client", "WebClient")
  }
}

private import semmle.code.java.security.RequestForgery

private class SpringWebClientRestTemplateGetForObject extends RequestForgerySink {
  SpringWebClientRestTemplateGetForObject() {
    exists(Method m, MethodCall mc, int i |
      m.getDeclaringType() instanceof SpringRestTemplate and
      m.hasName("getForObject") and
      mc.getMethod() = m
    |
      // Deal with two overloads, with third parameter type `Object...` and
      // `Map<String, ?>`. We cannot deal with mapvalue content easily but
      // there is a default implicit taint read at sinks that will catch it.
      this.asExpr() = mc.getArgument(i) and
      i >= 2
    )
  }
}
