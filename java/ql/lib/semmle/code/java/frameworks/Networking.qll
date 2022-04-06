/**
 * Definitions related to `java.net.*`.
 */

import semmle.code.java.Type

/** The type `java.net.URLConnection`. */
class TypeUrlConnection extends RefType {
  TypeUrlConnection() { this.hasQualifiedName("java.net", "URLConnection") }
}

/** The type `java.net.Socket`. */
class TypeSocket extends RefType {
  TypeSocket() { this.hasQualifiedName("java.net", "Socket") }
}

/** The type `javax.net.SocketFactory` */
class TypeSocketFactory extends RefType {
  TypeSocketFactory() { this.hasQualifiedName("javax.net", "SocketFactory") }
}

/** The type `java.net.URL`. */
class TypeUrl extends RefType {
  TypeUrl() { this.hasQualifiedName("java.net", "URL") }
}

/** The type `java.net.URI`. */
class TypeUri extends RefType {
  TypeUri() { this.hasQualifiedName("java.net", "URI") }
}

/** The method `java.net.URLConnection::getInputStream`. */
class UrlConnectionGetInputStreamMethod extends Method {
  UrlConnectionGetInputStreamMethod() {
    this.getDeclaringType() instanceof TypeUrlConnection and
    this.hasName("getInputStream") and
    this.hasNoParameters()
  }
}

/** DEPRECATED: Alias for UrlConnectionGetInputStreamMethod */
deprecated class URLConnectionGetInputStreamMethod = UrlConnectionGetInputStreamMethod;

/** The method `java.net.Socket::getInputStream`. */
class SocketGetInputStreamMethod extends Method {
  SocketGetInputStreamMethod() {
    this.getDeclaringType() instanceof TypeSocket and
    this.hasName("getInputStream") and
    this.hasNoParameters()
  }
}

/** The method `java.net.Socket::getOutputStream`. */
class SocketGetOutputStreamMethod extends Method {
  SocketGetOutputStreamMethod() {
    this.getDeclaringType() instanceof TypeSocket and
    this.hasName("getOutputStream") and
    this.hasNoParameters()
  }
}

/** A method or constructor call that returns a new `URI`. */
class UriCreation extends Call {
  UriCreation() {
    this.getCallee().getDeclaringType() instanceof TypeUri and
    (this instanceof ClassInstanceExpr or this.getCallee().hasName("create"))
  }

  /**
   * Gets the host argument of the newly created URI. In the case where the
   * host is specified separately, this is only the host. In the case where the
   * URI is parsed from an input string, such as in
   * `URI("http://foo.com/mypath")`, this is the entire argument passed in,
   * that is `"http://foo.com/mypath"`.
   */
  abstract Expr getHostArg();

  /**
   * Gets the scheme argument of the newly created URI. In the case where the
   * scheme is specified separately, this is only the scheme. In the case where the
   * URI is parsed from an input string, such as in
   * `URI("http://foo.com/mypath")`, this is the entire argument passed in,
   * that is `"http://foo.com/mypath"`.
   */
  abstract Expr getSchemeArg();
}

/** A `java.net.URI` constructor call. */
class UriConstructorCall extends ClassInstanceExpr, UriCreation {
  override Expr getHostArg() {
    // URI(String str)
    result = this.getArgument(0) and this.getNumArgument() = 1
    or
    // URI(String scheme, String ssp, String fragment)
    // URI(String scheme, String host, String path, String fragment)
    // URI(String scheme, String authority, String path, String query, String fragment)
    result = this.getArgument(1) and this.getNumArgument() = [3, 4, 5]
    or
    // URI(String scheme, String userInfo, String host, int port, String path, String query,
    //    String fragment)
    result = this.getArgument(2) and this.getNumArgument() = 7
  }

  override Expr getSchemeArg() { result = this.getArgument(0) }
}

/** A call to `java.net.URI::create`. */
class UriCreate extends UriCreation {
  UriCreate() { this.getCallee().hasName("create") }

  override Expr getHostArg() { result = this.getArgument(0) }

  override Expr getSchemeArg() { result = this.getArgument(0) }
}

/** A `java.net.URL` constructor call. */
class UrlConstructorCall extends ClassInstanceExpr {
  UrlConstructorCall() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  /** Gets the host argument of the newly created URL. */
  Expr getHostArg() {
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
    this.getNumArgument() = 3 and
    this.getConstructor().getParameterType(2) instanceof TypeString and
    result = this.getArgument(1)
  }

  /** Gets the argument that corresponds to the protocol of the URL. */
  Expr getProtocolArg() {
    // In all cases except where the first parameter is a URL, the argument
    // containing the protocol is the first one, otherwise it is the second.
    if this.getConstructor().getParameterType(0) instanceof TypeUrl
    then result = this.getArgument(1)
    else result = this.getArgument(0)
  }
}

/** The method `java.net.URL::openStream`. */
class UrlOpenStreamMethod extends Method {
  UrlOpenStreamMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openStream"
  }
}

/** The method `java.net.URL::openConnection`. */
class UrlOpenConnectionMethod extends Method {
  UrlOpenConnectionMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}

/** The method `javax.net.SocketFactory::createSocket`. */
class CreateSocketMethod extends Method {
  CreateSocketMethod() {
    this.hasName("createSocket") and
    this.getDeclaringType().getAnAncestor() instanceof TypeSocketFactory
  }
}

/** The method `javax.net.Socket::connect`. */
class SocketConnectMethod extends Method {
  SocketConnectMethod() {
    this.hasName("connect") and
    this.getDeclaringType() instanceof TypeSocket
  }
}

/**
 * A string matching private host names of IPv4 and IPv6, which only matches the host portion therefore checking for port is not necessary.
 * Several examples are localhost, reserved IPv4 IP addresses including 127.0.0.1, 10.x.x.x, 172.16.x,x, 192.168.x,x, and reserved IPv6 addresses including [0:0:0:0:0:0:0:1] and [::1]
 */
class PrivateHostName extends string {
  bindingset[this]
  PrivateHostName() {
    this.regexpMatch("(?i)localhost(?:[:/?#].*)?|127\\.0\\.0\\.1(?:[:/?#].*)?|10(?:\\.[0-9]+){3}(?:[:/?#].*)?|172\\.16(?:\\.[0-9]+){2}(?:[:/?#].*)?|192.168(?:\\.[0-9]+){2}(?:[:/?#].*)?|\\[?0:0:0:0:0:0:0:1\\]?(?:[:/?#].*)?|\\[?::1\\]?(?:[:/?#].*)?")
  }
}
