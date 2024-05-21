/** Provides classes to reason about URL redirect attacks. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.ApacheHttp
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.frameworks.JaxWS
private import semmle.code.java.security.RequestForgery

/** A URL redirection sink. */
abstract class UrlRedirectSink extends ApiSinkNode { }

/** A URL redirection sanitizer. */
abstract class UrlRedirectSanitizer extends DataFlow::Node { }

/** A default sink represeting methods susceptible to URL redirection attacks. */
private class DefaultUrlRedirectSink extends UrlRedirectSink {
  DefaultUrlRedirectSink() { sinkNode(this, "url-redirection") }
}

/** A Servlet URL redirection sink. */
private class ServletUrlRedirectSink extends UrlRedirectSink {
  ServletUrlRedirectSink() {
    exists(MethodCall ma |
      ma.getMethod() instanceof HttpServletResponseSendRedirectMethod and
      this.asExpr() = ma.getArgument(0)
    )
    or
    exists(MethodCall ma |
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

private class DefaultUrlRedirectSanitizer extends UrlRedirectSanitizer instanceof RequestForgerySanitizer
{ }
