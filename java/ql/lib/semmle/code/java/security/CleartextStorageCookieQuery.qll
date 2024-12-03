/** Provides classes and predicates to reason about cleartext storage in cookies. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.CleartextStorageQuery
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.FlowSources

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
    exists(DataFlow::Node n |
      cookieStore(n, result) and
      CookieToStoreFlow::flow(DataFlow::exprNode(this), n)
    )
  }
}

private predicate cookieStore(DataFlow::Node cookie, Expr store) {
  exists(MethodCall m, Method def |
    m.getMethod() = def and
    def.getName() = "addCookie" and
    def.getDeclaringType().hasQualifiedName("javax.servlet.http", "HttpServletResponse") and
    store = m and
    cookie.asExpr() = m.getAnArgument()
  )
}

/**
 * A cookie source node.
 */
private class CookieSource extends ApiSourceNode {
  CookieSource() { this.asExpr() instanceof Cookie }
}

/**
 * A cookie store sink node.
 */
private class CookieStoreSink extends ApiSinkNode {
  CookieStoreSink() { cookieStore(this, _) }
}

private module CookieToStoreFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof CookieSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CookieStoreSink }
}

private module CookieToStoreFlow = DataFlow::Global<CookieToStoreFlowConfig>;

private Expr cookieInput(Cookie c) { result = c.getArgument(1) }
