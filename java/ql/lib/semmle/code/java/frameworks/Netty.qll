/** Provides definitions related to the Netty framework. */

import java

/** The interface `Cookie` in the packages `io.netty.handler.codec.http` and `io.netty.handler.codec.http.cookie`. */
class NettyCookie extends Interface {
  NettyCookie() { this.hasQualifiedName("io.netty.handler.codec.http" + [".cookie", ""], "Cookie") }
}

/** The class `DefaultCookie` in the packages `io.netty.handler.codec.http` and `io.netty.handler.codec.http.cookie`. */
class NettyDefaultCookie extends Class {
  NettyDefaultCookie() {
    this.hasQualifiedName("io.netty.handler.codec.http" + [".cookie", ""], "DefaultCookie")
  }
}

/** The method `setValue` of the interface `Cookie` or a class implementing it. */
class NettySetCookieValueMethod extends Method {
  NettySetCookieValueMethod() {
    this.getDeclaringType*() instanceof NettyCookie and
    this.hasName("setValue")
  }
}
