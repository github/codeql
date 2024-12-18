/**
 * Provides classes for working with Spring web clients.
 */

import java
import SpringHttp
private import semmle.code.java.security.RequestForgery

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

/** The method `getForObject` on `org.springframework.web.reactive.function.client.RestTemplate`. */
class SpringRestTemplateGetForObjectMethod extends Method {
  SpringRestTemplateGetForObjectMethod() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.hasName("getForObject")
  }
}

/** A call to the method `getForObject` on `org.springframework.web.reactive.function.client.RestTemplate`. */
class SpringRestTemplateGetForObjectMethodCall extends MethodCall {
  SpringRestTemplateGetForObjectMethodCall() {
    this.getMethod() instanceof SpringRestTemplateGetForObjectMethod
  }

  /** Gets the first argument, if it is a compile time constant. */
  CompileTimeConstantExpr getConstantUrl() { result = this.getArgument(0) }

  /**
   * Holds if the first argument is a compile time constant and it has a
   * placeholder at offset `offset`, and there are `idx` placeholders that
   * appear before it.
   */
  predicate urlHasPlaceholderAtOffset(int idx, int offset) {
    exists(
      this.getConstantUrl()
          .getStringValue()
          .replaceAll("\\{", "  ")
          .replaceAll("\\}", "  ")
          .regexpFind("\\{[^}]*\\}", idx, offset)
    )
  }
}

private class SpringWebClientRestTemplateGetForObject extends RequestForgerySink {
  SpringWebClientRestTemplateGetForObject() {
    exists(SpringRestTemplateGetForObjectMethodCall mc, int i |
      // Note that the first argument is modeled as a request forgery sink
      // separately. This model is for arguments beyond the first two. There
      // are two relevant overloads, one with third parameter type `Object...`
      // and one with third parameter type `Map<String, ?>`. For the latter we
      // cannot deal with MapValue content easily but there is a default
      // implicit taint read at sinks that will catch it.
      i >= 0 and
      this.asExpr() = mc.getArgument(i + 2)
    |
      // If we can determine that part of mc.getArgument(0) is a hostname
      // sanitizing prefix, then we count how many placeholders occur before it
      // and only consider that many arguments beyond the first two as sinks.
      // For the `Map<String, ?>` overload this has the effect of only
      // considering the map values as sinks if there is at least one
      // placeholder in the URL before the hostname sanitizing prefix.
      exists(int offset |
        mc.urlHasPlaceholderAtOffset(i, offset) and
        offset < mc.getConstantUrl().(HostnameSanitizingPrefix).getOffset()
      )
      or
      // If we cannot determine that part of mc.getArgument(0) is a hostname
      // sanitizing prefix, but it is a compile time constant and we can get
      // its string value, then we count how many placeholders occur in it
      // and only consider that many arguments beyond the first two as sinks.
      // For the `Map<String, ?>` overload this has the effect of only
      // considering the map values as sinks if there is at least one
      // placeholder in the URL.
      not mc.getConstantUrl() instanceof HostnameSanitizingPrefix and
      mc.urlHasPlaceholderAtOffset(i, _)
      or
      // If we cannot determine the string value of mc.getArgument(0), then we
      // conservatively consider all arguments as sinks.
      not exists(mc.getConstantUrl().getStringValue())
    )
  }
}
