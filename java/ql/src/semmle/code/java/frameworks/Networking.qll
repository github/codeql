/*
 * Definitions related to `java.net.*`.
 */

import semmle.code.java.Type

class TypeUrlConnection extends RefType {
  TypeUrlConnection() { hasQualifiedName("java.net", "URLConnection") }
}

class TypeSocket extends RefType {
  TypeSocket() { hasQualifiedName("java.net", "Socket") }
}

class URLConnectionGetInputStreamMethod extends Method {
  URLConnectionGetInputStreamMethod() {
    getDeclaringType() instanceof TypeUrlConnection and
    hasName("getInputStream") and
    hasNoParameters()
  }
}

class SocketGetInputStreamMethod extends Method {
  SocketGetInputStreamMethod() {
    getDeclaringType() instanceof TypeSocket and
    hasName("getInputStream") and
    hasNoParameters()
  }
}
