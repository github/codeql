/** Provides classes to reason about URL redirect attacks. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.ApacheHttp
private import semmle.code.java.frameworks.JaxWS

/** A URL redirection sink. */
abstract class UrlRedirectSink extends DataFlow::Node { }

/** A default sink represeting methods susceptible to URL redirection attacks. */
private class DefaultUrlRedirectSink extends UrlRedirectSink {
  DefaultUrlRedirectSink() { sinkNode(this, "url-redirect") }
}

/** A Servlet URL redirection sink. */
private class ServletUrlRedirectSink extends UrlRedirectSink {
  ServletUrlRedirectSink() {
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

/** A URL redirection sink from Apache Http components. */
private class ApacheUrlRedirectSink extends UrlRedirectSink {
  ApacheUrlRedirectSink() {
    exists(ApacheHttpSetHeader c |
      c.getName().(CompileTimeConstantExpr).getStringValue() = "Location" and
      this.asExpr() = c.getValue()
    )
  }
}
