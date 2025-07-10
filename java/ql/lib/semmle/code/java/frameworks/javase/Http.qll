/**
 * Provides classes and predicates related to `java.net.http.*`.
 */

import java

/** The interface representing `HttpRequest.Builder`. */
class TypeHttpRequestBuilder extends Interface {
  TypeHttpRequestBuilder() { this.hasQualifiedName("java.net.http", "HttpRequest$Builder") }
}

/** The interface representing `java.net.http.HttpRequest`. */
class TypeHttpRequest extends Interface {
  TypeHttpRequest() { this.hasQualifiedName("java.net.http", "HttpRequest") }
}

/** The `uri` method on `java.net.http.HttpRequest.Builder`. */
class HttpBuilderUri extends Method {
  HttpBuilderUri() {
    this.getDeclaringType() instanceof TypeHttpRequestBuilder and
    this.getName() = "uri"
  }
}
