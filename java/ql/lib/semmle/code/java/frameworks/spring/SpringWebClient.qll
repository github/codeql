/**
 * Provides classes for working with Spring web clients.
 */
overlay[local?]
module;

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

/**
 * A method on `org.springframework.web.client.RestTemplate`
 * which has a parameter `uriVariables` (which can have type `Object..` or
 * `Map<String, ?>`) which contains variables to be expanded into the URL
 * template in parameter 0.
 */
private class SpringRestTemplateMethodWithUriVariablesParameter extends Method {
  int pos;

  SpringRestTemplateMethodWithUriVariablesParameter() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    (
      this.hasName("delete") and pos = 1
      or
      this.hasName("exchange") and pos = 4
      or
      this.hasName("execute") and pos = 4
      or
      this.hasName("getForEntity") and pos = 2
      or
      this.hasName("getForObject") and pos = 2
      or
      this.hasName("headForHeaders") and pos = 1
      or
      this.hasName("optionsForAllow") and pos = 1
      or
      this.hasName("patchForObject") and pos = 3
      or
      this.hasName("postForEntity") and pos = 3
      or
      this.hasName("postForLocation") and pos = 2
      or
      this.hasName("postForObject") and pos = 3
      or
      this.hasName("put") and pos = 2
    )
  }

  int getUriVariablesPosition() { result = pos }
}

/** Gets the first argument, if it is a compile time constant. */
pragma[inline]
private CompileTimeConstantExpr getConstantUrl(MethodCall mc) { result = mc.getArgument(0) }

pragma[inline]
private predicate urlHasPlaceholderAtOffset(MethodCall mc, int idx, int offset) {
  exists(
    getConstantUrl(mc)
        .getStringValue()
        .replaceAll("\\{", "  ")
        .replaceAll("\\}", "  ")
        .regexpFind("\\{[^}]*\\}", idx, offset)
  )
}

private class SpringWebClientRestTemplateGetForObject extends RequestForgerySink {
  SpringWebClientRestTemplateGetForObject() {
    exists(SpringRestTemplateMethodWithUriVariablesParameter m, MethodCall mc, int i |
      // Note that the first argument is modeled as a request forgery sink
      // separately. This model is for arguments beyond the first two. There
      // are two relevant overloads, one with third parameter type `Object...`
      // and one with third parameter type `Map<String, ?>`. For the latter we
      // cannot deal with MapValue content easily but there is a default
      // implicit taint read at sinks that will catch it.
      mc.getMethod() = m and
      i >= 0 and
      this.asExpr() = mc.getArgument(m.getUriVariablesPosition() + i)
    |
      // If we can determine that part of mc.getArgument(0) is a hostname
      // sanitizing prefix, then we count how many placeholders occur before it
      // and only consider that many arguments beyond the first two as sinks.
      // For the `Map<String, ?>` overload this has the effect of only
      // considering the map values as sinks if there is at least one
      // placeholder in the URL before the hostname sanitizing prefix.
      exists(int offset |
        urlHasPlaceholderAtOffset(mc, i, offset) and
        offset < getConstantUrl(mc).(HostnameSanitizingPrefix).getOffset()
      )
      or
      // If we cannot determine that part of mc.getArgument(0) is a hostname
      // sanitizing prefix, but it is a compile time constant and we can get
      // its string value, then we count how many placeholders occur in it
      // and only consider that many arguments beyond the first two as sinks.
      // For the `Map<String, ?>` overload this has the effect of only
      // considering the map values as sinks if there is at least one
      // placeholder in the URL.
      not getConstantUrl(mc) instanceof HostnameSanitizingPrefix and
      urlHasPlaceholderAtOffset(mc, i, _)
      or
      // If we cannot determine the string value of mc.getArgument(0), then we
      // conservatively consider all arguments as sinks.
      not exists(getConstantUrl(mc).getStringValue())
    )
  }
}
