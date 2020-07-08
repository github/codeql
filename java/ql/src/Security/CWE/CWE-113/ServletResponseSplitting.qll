import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ResponseSplitting

/**
 * Header-splitting sinks. Expressions that end up in an HTTP header.
 */
class ServletHeaderSplittingSink extends HeaderSplittingSink {
  ServletHeaderSplittingSink() {
    exists(ResponseAddCookieMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.getExpr() = ma.getArgument(0)
    )
    or
    exists(ResponseAddHeaderMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.getExpr() = ma.getAnArgument()
    )
    or
    exists(ResponseSetHeaderMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.getExpr() = ma.getAnArgument()
    )
    or
    exists(JaxRsResponseBuilder builder, Method m |
      m = builder.getAMethod() and m.getName() = "header"
    |
      this.getExpr() = m.getAReference().getArgument(1)
    )
  }
}

class TrustedServletSource extends TrustedSource {
  TrustedServletSource() {
    this.asExpr().(MethodAccess).getMethod() instanceof HttpServletRequestGetHeaderMethod or
    this.asExpr().(MethodAccess).getMethod() instanceof CookieGetNameMethod
  }
}
