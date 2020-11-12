/**
 * Provides classes for identifying methods called by the Java net Http package.
 */

import java

/** The interface representing `HttpRequest.Builder`. */
class TypeHttpRequestBuilder extends Interface {
  TypeHttpRequestBuilder() { hasQualifiedName("java.net.http", "HttpRequest$Builder") }
}

/** A class representing `java.net.http.HttpRequest`. */
class TypeHttpRequest extends Interface {
  TypeHttpRequest() { hasQualifiedName("java.net.http", "HttpRequest") }
}

/** The `uri` method on `java.net.http.HttpRequest.Builder`. */
class HttpBuilderUri extends Method {
  HttpBuilderUri() {
    this.getDeclaringType() instanceof TypeHttpRequestBuilder and
    this.getName() = "uri"
  }
}
