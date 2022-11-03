/** Provides classes to reason about header splitting attacks. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.JaxWS
private import semmle.code.java.dataflow.ExternalFlow

/** A sink that is vulnerable to an HTTP header splitting attack. */
abstract class HeaderSplittingSink extends DataFlow::Node { }

private class DefaultHeaderSplittingSink extends HeaderSplittingSink {
  DefaultHeaderSplittingSink() { sinkNode(this, "header-splitting") }
}

private class HeaderSplittingSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.servlet.http;HttpServletResponse;false;addCookie;;;Argument[0];header-splitting",
        "javax.servlet.http;HttpServletResponse;false;addHeader;;;Argument[0..1];header-splitting",
        "javax.servlet.http;HttpServletResponse;false;setHeader;;;Argument[0..1];header-splitting",
        "javax.ws.rs.core;ResponseBuilder;false;header;;;Argument[1];header-splitting"
      ]
  }
}

/** A source that introduces data considered safe to use by a header splitting source. */
abstract class SafeHeaderSplittingSource extends DataFlow::Node {
  SafeHeaderSplittingSource() { this instanceof RemoteFlowSource }
}

/** A default source that introduces data considered safe to use by a header splitting source. */
private class DefaultSafeHeaderSplittingSource extends SafeHeaderSplittingSource {
  DefaultSafeHeaderSplittingSource() {
    this.asExpr().(MethodAccess).getMethod() instanceof HttpServletRequestGetHeaderMethod or
    this.asExpr().(MethodAccess).getMethod() instanceof CookieGetNameMethod
  }
}
