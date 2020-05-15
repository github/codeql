import java

/** An interface for web requests in the Spring framework. */
class SpringWebRequest extends Class {
  SpringWebRequest() {
    hasQualifiedName("org.springframework.web.context.request", "WebRequest")
  }
}

/** An interface for web requests in the Spring framework. */
class SpringNativeWebRequest extends Class {
  SpringNativeWebRequest() {
    hasQualifiedName("org.springframework.web.context.request", "NativeWebRequest")
  }
}