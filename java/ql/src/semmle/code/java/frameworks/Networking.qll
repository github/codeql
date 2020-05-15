/**
 * Definitions related to `java.net.*`.
 */

import semmle.code.java.Type

/** The type `java.net.URLConnection`. */
class TypeUrlConnection extends RefType {
  TypeUrlConnection() { hasQualifiedName("java.net", "URLConnection") }
}

/** The type `java.net.Socket`. */
class TypeSocket extends RefType {
  TypeSocket() { hasQualifiedName("java.net", "Socket") }
}

/** The type `java.net.URL`. */
class TypeUrl extends RefType {
  TypeUrl() { hasQualifiedName("java.net", "URL") }
}

/** The type `java.net.URI`. */
class TypeUri extends RefType {
  TypeUri() { hasQualifiedName("java.net", "URI") }
}

/** The method `java.net.URLConnection::getInputStream`. */
class URLConnectionGetInputStreamMethod extends Method {
  URLConnectionGetInputStreamMethod() {
    getDeclaringType() instanceof TypeUrlConnection and
    hasName("getInputStream") and
    hasNoParameters()
  }
}

/** The method `java.net.Socket::getInputStream`. */
class SocketGetInputStreamMethod extends Method {
  SocketGetInputStreamMethod() {
    getDeclaringType() instanceof TypeSocket and
    hasName("getInputStream") and
    hasNoParameters()
  }
}
