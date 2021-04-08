/**
 * Provides classes for working with Spring web requests.
 */

import java

/** An interface for web requests in the Spring framework. */
class SpringWebRequest extends Class {
  SpringWebRequest() {
    this.hasQualifiedName("org.springframework.web.context.request", "WebRequest")
  }
}

/** An interface for web requests in the Spring framework. */
class SpringNativeWebRequest extends Class {
  SpringNativeWebRequest() {
    this.hasQualifiedName("org.springframework.web.context.request", "NativeWebRequest")
  }
}
