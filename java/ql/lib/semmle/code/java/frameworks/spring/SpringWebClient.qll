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
      mc.getMethod() = m and
      // Note that mc.getArgument(0) is modeled separately. This model is for
      // arguments beyond the first two. There are two relevant overloads, one
      // with third parameter type `Object...` and one with third parameter
      // type `Map<String, ?>`. For the latter we cannot deal with mapvalue
      // content easily but there is a default implicit taint read at sinks
      // that will catch it.
      this.asExpr() = mc.getArgument(i + 2) and
      i >= 0
    |
      // If we can determine that part of mc.getArgument(0) is a hostname
      // sanitizing prefix, then we count how many placeholders occur before it
      // and only consider that many arguments beyond the first two as sinks.
      // For the `Map<String, ?>` overload this has the effect of only
      // considering the map values as sinks if there is at least one
      // placeholder in the URL before the hostname sanitizing prefix.
      exists(HostnameSanitizingPrefix hsp |
        hsp = mc.getArgument(0) and
        i <=
          max(int occurrenceIndex, int occurrenceOffset |
            exists(
              hsp.getStringValue().regexpFind("\\{[^}]*\\}", occurrenceIndex, occurrenceOffset)
            ) and
            occurrenceOffset < hsp.getOffset()
          |
            occurrenceIndex
          )
      )
      or
      // If we cannot determine that part of mc.getArgument(0) is a hostname
      // sanitizing prefix, but it is a compile time constant and we can get
      // its string value, then we count how many placeholders occur in it
      // and only consider that many arguments beyond the first two as sinks.
      // For the `Map<String, ?>` overload this has the effect of only
      // considering the map values as sinks if there is at least one
      // placeholder in the URL.
      not mc.getArgument(0) instanceof HostnameSanitizingPrefix and
      i <=
        max(int occurrenceIndex |
          exists(
            mc.getArgument(0)
                .(CompileTimeConstantExpr)
                .getStringValue()
                .regexpFind("\\{[^}]*\\}", occurrenceIndex, _)
          )
        |
          occurrenceIndex
        )
      or
      // If we cannot determine the string value of mc.getArgument(0), then we
      // conservatively consider all arguments as sinks.
      not exists(mc.getArgument(0).(CompileTimeConstantExpr).getStringValue())
    )
  }
}
