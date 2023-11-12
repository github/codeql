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
  DefaultHeaderSplittingSink() { sinkNode(this, "response-splitting") }
}

/** A source that introduces data considered safe to use by a header splitting source. */
abstract class SafeHeaderSplittingSource extends DataFlow::Node instanceof RemoteFlowSource { }

/** A default source that introduces data considered safe to use by a header splitting source. */
private class DefaultSafeHeaderSplittingSource extends SafeHeaderSplittingSource {
  DefaultSafeHeaderSplittingSource() {
    this.asExpr().(MethodCall).getMethod() instanceof HttpServletRequestGetHeaderMethod or
    this.asExpr().(MethodCall).getMethod() instanceof CookieGetNameMethod
  }
}
