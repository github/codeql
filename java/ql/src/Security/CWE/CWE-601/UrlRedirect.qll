import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.DataFlow

/**
 * A URL redirection sink.
 */
class UrlRedirectSink extends DataFlow::ExprNode {
  UrlRedirectSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof HttpServletResponseSendRedirectMethod and
      this.asExpr() = ma.getArgument(0)
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof ResponseSetHeaderMethod or
      ma.getMethod() instanceof ResponseAddHeaderMethod
    |
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "Location" and
      this.asExpr() = ma.getArgument(1)
    )
  }
}
