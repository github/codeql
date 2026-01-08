/** Provides classes to reason about header splitting attacks. */
overlay[local?]
module;

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.JaxWS
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.Sanitizers

/** A sink that is vulnerable to an HTTP header splitting attack. */
abstract class HeaderSplittingSink extends DataFlow::Node { }

private class DefaultHeaderSplittingSink extends HeaderSplittingSink {
  DefaultHeaderSplittingSink() { sinkNode(this, "response-splitting") }
}

/** A sanitizer for an HTTP header splitting attack. */
abstract class HeaderSplittingSanitizer extends DataFlow::Node { }

private class SimpleTypeHeaderSplittingSanitizer extends HeaderSplittingSanitizer instanceof SimpleTypeSanitizer
{ }

private class ExternalHeaderSplittingSanitizer extends HeaderSplittingSanitizer {
  ExternalHeaderSplittingSanitizer() { barrierNode(this, "response-splitting") }
}

private class NewlineRemovalHeaderSplittingSanitizer extends HeaderSplittingSanitizer {
  NewlineRemovalHeaderSplittingSanitizer() {
    exists(MethodCall ma, string methodName, CompileTimeConstantExpr target |
      this.asExpr() = ma and
      ma.getMethod().hasQualifiedName("java.lang", "String", methodName) and
      target = ma.getArgument(0) and
      (
        methodName = "replace" and target.getIntValue() = [10, 13] // 10 == "\n", 13 == "\r"
        or
        methodName = "replaceAll" and
        target.getStringValue().regexpMatch(".*([\n\r]|\\[\\^[^\\]\r\n]*\\]).*")
      )
    )
  }
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
