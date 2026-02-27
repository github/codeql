/**
 * Provides classes for identifying Micronaut HTTP controllers and their request handling methods.
 */
overlay[local?]
module;

import java

/** An annotation type that identifies Micronaut controllers. */
class MicronautControllerAnnotation extends AnnotationType {
  MicronautControllerAnnotation() {
    this.hasQualifiedName("io.micronaut.http.annotation", "Controller")
  }
}

/**
 * A class annotated as a Micronaut `@Controller`.
 */
class MicronautController extends Class {
  MicronautController() {
    this.getAnAnnotation().getType() instanceof MicronautControllerAnnotation
  }
}

/** An annotation type that identifies Micronaut HTTP method mappings. */
class MicronautHttpMethodAnnotation extends AnnotationType {
  MicronautHttpMethodAnnotation() {
    this.getPackage().hasName("io.micronaut.http.annotation") and
    this.hasName([
        "Get", "Post", "Put", "Delete", "Patch", "Head", "Options", "Trace", "CustomHttpMethod"
      ])
  }
}

/**
 * A method on a Micronaut controller that is executed in response to an HTTP request.
 */
class MicronautRequestMappingMethod extends Method {
  MicronautRequestMappingMethod() {
    this.getDeclaringType() instanceof MicronautController and
    this.getAnAnnotation().getType() instanceof MicronautHttpMethodAnnotation
  }

  /** Gets a request mapping parameter. */
  MicronautRequestMappingParameter getARequestParameter() { result = this.getAParameter() }
}

/** A Micronaut annotation indicating remote user input from HTTP requests. */
class MicronautHttpInputAnnotation extends Annotation {
  MicronautHttpInputAnnotation() {
    exists(AnnotationType a |
      a = this.getType() and
      a.getPackage().hasName("io.micronaut.http.annotation")
    |
      a.hasName([
          "PathVariable", "QueryValue", "Body", "Header", "CookieValue", "Part", "RequestAttribute"
        ])
    )
  }
}

/** A parameter of a `MicronautRequestMappingMethod`. */
class MicronautRequestMappingParameter extends Parameter {
  MicronautRequestMappingParameter() { this.getCallable() instanceof MicronautRequestMappingMethod }

  /** Holds if the parameter should not be considered a direct source of taint. */
  predicate isNotDirectlyTaintedInput() {
    this.getType().(RefType).getAnAncestor().hasQualifiedName("io.micronaut.http", "HttpResponse")
    or
    this.getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("io.micronaut.http", "MutableHttpResponse")
    or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.security", "Principal")
    or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.util", "Locale")
    or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.util", "TimeZone")
    or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.time", "ZoneId")
    or
    // @Value/@Property parameters are configuration injection, not HTTP input
    this.getAnAnnotation()
        .getType()
        .hasQualifiedName("io.micronaut.context.annotation", ["Value", "Property"])
  }

  private predicate isExplicitlyTaintedInput() {
    // The MicronautHttpInputAnnotation allows access to the URI path,
    // request parameters, cookie values, headers, and the body of the request.
    this.getAnAnnotation() instanceof MicronautHttpInputAnnotation
    or
    // A @RequestBean parameter binds multiple request attributes into a POJO
    this.getAnAnnotation().getType() instanceof MicronautRequestBeanAnnotation
    or
    // An HttpRequest parameter provides access to request data
    this.getType()
        .(RefType)
        .getASourceSupertype*()
        .hasQualifiedName("io.micronaut.http", "HttpRequest")
    or
    // InputStream or Reader parameters allow access to the body of a request
    this.getType().(RefType).getAnAncestor() instanceof TypeInputStream
    or
    this.getType().(RefType).getAnAncestor().hasQualifiedName("java.io", "Reader")
  }

  /** Holds if the input is tainted (i.e. comes from user-controlled input). */
  predicate isTaintedInput() {
    this.isExplicitlyTaintedInput()
    or
    not this.isNotDirectlyTaintedInput()
  }
}

/** An annotation type that identifies Micronaut error handler methods. */
class MicronautErrorAnnotation extends AnnotationType {
  MicronautErrorAnnotation() { this.hasQualifiedName("io.micronaut.http.annotation", "Error") }
}

/** A method annotated with Micronaut's `@Error` that handles exceptions. */
class MicronautErrorHandler extends Method {
  MicronautErrorHandler() { this.getAnAnnotation().getType() instanceof MicronautErrorAnnotation }

  /** Gets a parameter that carries user-controlled request data. */
  Parameter getARemoteParameter() {
    result = this.getAParameter() and
    result
        .getType()
        .(RefType)
        .getASourceSupertype*()
        .hasQualifiedName("io.micronaut.http", "HttpRequest")
  }
}

/** An annotation type that identifies Micronaut request bean parameters. */
class MicronautRequestBeanAnnotation extends AnnotationType {
  MicronautRequestBeanAnnotation() {
    this.hasQualifiedName("io.micronaut.http.annotation", "RequestBean")
  }
}
