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
 * which has a parameter `uriVariables` (which can have type `Object...` or
 * `Map<String, ?>`) which contains variables to be expanded into the URL
 * template in parameter 0.
 */
private class SpringRestTemplateMethodWithUriVariablesParameter extends Method {
  int pos;

  SpringRestTemplateMethodWithUriVariablesParameter() {
    this.getDeclaringType() instanceof SpringRestTemplate and
    this.getParameter(pos).getName() = "uriVariables"
  }

  int getUriVariablesPosition() { result = pos }
}

/** Gets the first argument of `mc`, if it is a compile-time constant. */
pragma[inline]
private CompileTimeConstantExpr getConstantUrl(MethodCall mc) { result = mc.getArgument(0) }

/**
 * Holds if the first argument of `mc` is a compile-time constant URL template
 * which has its `idx`-th placeholder at the offset `offset`.
 */
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

private class SpringWebClientRestTemplateUriVariable extends RequestForgerySink {
  SpringWebClientRestTemplateUriVariable() {
    exists(SpringRestTemplateMethodWithUriVariablesParameter m, MethodCall mc, int i |
      // Note that the first argument of `m` is modeled as a request forgery
      // sink separately. This model is for arguments corresponding to the
      // `uriVariables` parameter. There are always two relevant overloads, one
      // with parameter type `Object...` and one with parameter type
      // `Map<String, ?>`. For the latter we cannot deal with MapValue content
      // easily but there is a default implicit taint read at sinks that will
      // catch it.
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
