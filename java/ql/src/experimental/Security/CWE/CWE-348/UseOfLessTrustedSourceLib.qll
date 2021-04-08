import java
import DataFlow
import semmle.code.java.dataflow.DataFlow
import experimental.semmle.code.java.Logging

/** A data flow source of the value of the `x-forwarded-for` field in the `header`. */
class UseOfLessTrustedSource extends DataFlow::Node {
  UseOfLessTrustedSource() {
    exists(MethodAccess ma |
      ma.getMethod().hasName("getHeader") and
      ma.getArgument(0).toString().toLowerCase() = "\"x-forwarded-for\"" and
      ma = this.asExpr()
    )
  }
}

/** A data flow sink of method return or log output or local print. */
class UseOfLessTrustedSink extends DataFlow::Node {
  UseOfLessTrustedSink() {
    exists(ReturnStmt rs | rs.getResult() = this.asExpr())
    or
    exists(MethodAccess ma |
      ma.getMethod().getName() in ["print", "println"] and
      (
        ma.getMethod().getDeclaringType().hasQualifiedName("java.io", "PrintWriter") or
        ma.getMethod().getDeclaringType().hasQualifiedName("java.io", "PrintStream")
      ) and
      ma.getAnArgument() = this.asExpr()
    )
    or
    exists(LoggingCall lc | lc.getAnArgument() = this.asExpr())
  }
}

/** A method that split string. */
class SplitMethod extends Method {
  SplitMethod() {
    this.getNumberOfParameters() = 1 and
    this.hasQualifiedName("java.lang", "String", "split")
  }
}

/**
 * A call to the ServletRequest.getHeader method and the argument are
 * `wl-proxy-client-ip`/`proxy-client-ip`/`http_client_ip`/`http_x_forwarded_for`/`x-real-ip`.
 */
class HeaderIpCall extends MethodAccess {
  HeaderIpCall() {
    this.getMethod().hasName("getHeader") and
    this.getMethod()
        .getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("javax.servlet", "ServletRequest") and
    this.getArgument(0).toString().toLowerCase() in [
        "\"wl-proxy-client-ip\"", "\"proxy-client-ip\"", "\"http_client_ip\"",
        "\"http_x_forwarded_for\"", "\"x-real-ip\""
      ]
  }
}

/** A call to `ServletRequest.getRemoteAddr` method. */
class RemoteAddrCall extends MethodAccess {
  RemoteAddrCall() {
    this.getMethod().hasName("getRemoteAddr") and
    this.getMethod()
        .getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("javax.servlet", "ServletRequest")
  }
}

/** The first one in the method to get the ip value through `x-forwarded-for`. */
predicate xffIsFirstGet(Node node) {
  exists(HeaderIpCall hic |
    node.getEnclosingCallable() = hic.getEnclosingCallable() and
    node.getLocation().getEndLine() < hic.getLocation().getEndLine()
  )
  or
  exists(RemoteAddrCall rac |
    node.getEnclosingCallable() = rac.getEnclosingCallable() and
    node.getLocation().getEndLine() < rac.getLocation().getEndLine()
  )
  or
  not exists(HeaderIpCall hic, RemoteAddrCall rac |
    node.getEnclosingCallable() = hic.getEnclosingCallable() and
    node.getEnclosingCallable() = rac.getEnclosingCallable()
  )
}
