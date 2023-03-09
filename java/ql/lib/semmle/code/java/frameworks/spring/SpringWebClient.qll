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
