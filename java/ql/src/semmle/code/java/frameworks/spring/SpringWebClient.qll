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

/**
 * An abstract class representing all Spring Rest Template methods
 * which take an URL as an argument.
 */
abstract class SpringRestTemplateUrlMethods extends Method {
  /** Gets the argument which corresponds to a URL */
  abstract Argument getUrlArgument(MethodAccess ma);
}

/** Models `RestTemplate` class's `doExecute` method */
class RestTemplateDoExecute extends SpringRestTemplateUrlMethods {
  RestTemplateDoExecute() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("doExecute")
  }

  override Argument getUrlArgument(MethodAccess ma) {
    // doExecute(URI url, HttpMethod method, RequestCallback requestCallback,
    //  ResponseExtractor<T> responseExtractor)
    result = ma.getArgument(0)
  }
}

/** Models `RestTemplate` class's `exchange` method */
class RestTemplateExchange extends SpringRestTemplateUrlMethods {
  RestTemplateExchange() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("exchange")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `execute` method */
class RestTemplateExecute extends SpringRestTemplateUrlMethods {
  RestTemplateExecute() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("execute")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `getForEntity` method */
class RestTemplateGetForEntity extends SpringRestTemplateUrlMethods {
  RestTemplateGetForEntity() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("getForEntity")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `getForObject` method */
class RestTemplateGetForObject extends SpringRestTemplateUrlMethods {
  RestTemplateGetForObject() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("getForObject")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `patchForObject` method */
class RestTemplatePatchForObject extends SpringRestTemplateUrlMethods {
  RestTemplatePatchForObject() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("patchForObject")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `postForEntity` method */
class RestTemplatePostForEntity extends SpringRestTemplateUrlMethods {
  RestTemplatePostForEntity() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("postForEntity")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `postForLocation` method */
class RestTemplatePostForLocation extends SpringRestTemplateUrlMethods {
  RestTemplatePostForLocation() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("postForLocation")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `postForObject` method */
class RestTemplatePostForObject extends SpringRestTemplateUrlMethods {
  RestTemplatePostForObject() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("postForObject")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}

/** Models `RestTemplate` class's `put` method */
class RestTemplatePut extends SpringRestTemplateUrlMethods {
  RestTemplatePut() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("put")
  }

  override Argument getUrlArgument(MethodAccess ma) { result = ma.getArgument(0) }
}
