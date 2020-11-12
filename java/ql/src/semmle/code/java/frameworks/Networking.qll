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

/** Any expresion or call which returns a new URI. */
abstract class UriCreation extends Top {
  /**
   * Returns the host of the newly created URI.
   *  In the case where the host is specified separately, this returns only the host.
   *  In the case where the uri is parsed from an input string,
   *  such as in `URI(`http://foo.com/mypath')`,
   *  this returns the entire argument passed i.e. `http://foo.com/mypath'.
   */
  abstract Expr hostArg();
}

/** An URI constructor expression */
class UriConstructor extends ClassInstanceExpr, UriCreation {
  UriConstructor() { this.getConstructor().getDeclaringType().getQualifiedName() = "java.net.URI" }

  override Expr hostArg() {
    // URI​(String str)
    result = this.getArgument(0) and this.getNumArgument() = 1
    or
    // URI(String scheme, String ssp, String fragment)
    // URI​(String scheme, String host, String path, String fragment)
    // URI​(String scheme, String authority, String path, String query, String fragment)
    result = this.getArgument(1) and this.getNumArgument() = [3, 4, 5]
    or
    // URI​(String scheme, String userInfo, String host, int port, String path, String query,
    //    String fragment)
    result = this.getArgument(2) and this.getNumArgument() = 7
  }
}

class UriCreate extends Call, UriCreation {
  UriCreate() {
    this.getCallee().getName() = "create" and
    this.getCallee().getDeclaringType() instanceof TypeUri
  }

  override Expr hostArg() { result = this.getArgument(0) }
}

/* An URL constructor expression */
class UrlConstructor extends ClassInstanceExpr {
  UrlConstructor() { this.getConstructor().getDeclaringType().getQualifiedName() = "java.net.URL" }

  Expr hostArg() {
    // URL(String spec)
    this.getNumArgument() = 1 and result = this.getArgument(0)
    or
    // URL(String protocol, String host, int port, String file)
    // URL(String protocol, String host, int port, String file, URLStreamHandler handler)
    this.getNumArgument() = [4, 5] and result = this.getArgument(1)
    or
    // URL(String protocol, String host, String file)
    // but not
    // URL(URL context, String spec, URLStreamHandler handler)
    (
      this.getNumArgument() = 3 and
      this.getConstructor().getParameter(2).getType() instanceof TypeString
    ) and
    result = this.getArgument(1)
  }

  Expr protocolArg() {
    // In all cases except where the first parameter is a URL, the argument
    // containing the protocol is the first one, otherwise it is the second.
    if this.getConstructor().getParameter(0).getType().getName() = "URL"
    then result = this.getArgument(1)
    else result = this.getArgument(0)
  }
}

class UrlOpenStreamMethod extends Method {
  UrlOpenStreamMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openStream"
  }
}

class UrlOpenConnectionMethod extends Method {
  UrlOpenConnectionMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}
