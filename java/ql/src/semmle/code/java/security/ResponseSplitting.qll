/** Provides classes to reason about header splitting attacks. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.JaxWS

/** A sink that is vulnerable to an HTTP header splitting attack. */
abstract class HeaderSplittingSink extends DataFlow::Node { }

/** A source that introduces data considered safe to use by a header splitting source. */
abstract class SafeHeaderSplittingSource extends DataFlow::Node {
  SafeHeaderSplittingSource() { this instanceof RemoteFlowSource }
}

/** A sink that identifies a Java Servlet or JaxWs method that is vulnerable to an HTTP header splitting attack. */
private class ServletHeaderSplittingSink extends HeaderSplittingSink {
  ServletHeaderSplittingSink() {
    exists(ResponseAddCookieMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.asExpr() = ma.getArgument(0)
    )
    or
    exists(ResponseAddHeaderMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.asExpr() = ma.getAnArgument()
    )
    or
    exists(ResponseSetHeaderMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.asExpr() = ma.getAnArgument()
    )
    or
    exists(JaxRsResponseBuilder builder, Method m |
      m = builder.getAMethod() and m.getName() = "header"
    |
      this.asExpr() = m.getAReference().getArgument(1)
    )
  }
}

/** A default source that introduces data considered safe to use by a header splitting source. */
private class DefaultSafeHeaderSplittingSource extends SafeHeaderSplittingSource {
  DefaultSafeHeaderSplittingSource() {
    this.asExpr().(MethodAccess).getMethod() instanceof HttpServletRequestGetHeaderMethod or
    this.asExpr().(MethodAccess).getMethod() instanceof CookieGetNameMethod
  }
}
