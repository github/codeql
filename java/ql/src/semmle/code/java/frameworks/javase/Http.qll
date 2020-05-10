import java
import semmle.code.java.dataflow.FlowSources

/** A class representing `HttpRequest.Builder`. */
class TypeHttpRequestBuilder extends Interface {
  TypeHttpRequestBuilder() { hasQualifiedName("java.net.http", "HttpRequest$Builder") }
}

/** A class representing `java.net.http.HttpRequest`. */
class TypeHttpRequest extends Interface {
  TypeHttpRequest() { hasQualifiedName("java.net.http", "HttpRequest") }
}

/** A class representing `java.net.http.HttpRequest$Builder`'s `uri` method. */
class HttpBuilderUri extends Method {
  HttpBuilderUri() {
    this.getDeclaringType() instanceof TypeHttpRequestBuilder and
    this.getName() = "uri"
  }
}
