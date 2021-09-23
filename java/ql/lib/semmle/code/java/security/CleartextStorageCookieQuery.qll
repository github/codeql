/** Provides classes and predicates to reason about cleartext storage in cookies. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.security.CleartextStorageQuery

private class CookieCleartextStorageSink extends CleartextStorageSink {
  CookieCleartextStorageSink() { this.asExpr() = cookieInput(_) }
}

/** The instantiation of a cookie, which can act as storage. */
class Cookie extends Storable, ClassInstanceExpr {
  Cookie() {
    this.getConstructor().getDeclaringType().hasQualifiedName("javax.servlet.http", "Cookie")
  }

  /** Gets an input, for example `input` in `new Cookie("...", input);`. */
  override Expr getAnInput() { result = cookieInput(this) }

  /** Gets a store, for example `response.addCookie(cookie);`. */
  override Expr getAStore() {
    exists(CookieToStoreFlowConfig conf, DataFlow::Node n |
      cookieStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

private predicate cookieStore(DataFlow::Node cookie, Expr store) {
  exists(MethodAccess m, Method def |
    m.getMethod() = def and
    def.getName() = "addCookie" and
    def.getDeclaringType().hasQualifiedName("javax.servlet.http", "HttpServletResponse") and
    store = m and
    cookie.asExpr() = m.getAnArgument()
  )
}

private class CookieToStoreFlowConfig extends DataFlow3::Configuration {
  CookieToStoreFlowConfig() { this = "CookieToStoreFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof Cookie }

  override predicate isSink(DataFlow::Node sink) { cookieStore(sink, _) }
}

private Expr cookieInput(Cookie c) { result = c.getArgument(1) }
