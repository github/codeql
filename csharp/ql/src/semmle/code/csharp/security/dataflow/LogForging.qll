/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in log entries.
 */

import csharp

module LogForging {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.System
  import semmle.code.csharp.frameworks.system.text.RegularExpressions
  import semmle.code.csharp.security.Sanitizers
  import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink

  /**
   * A data flow source for untrusted user input used in log entries.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for untrusted user input used in log entries.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for untrusted user input used in log entries.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for untrusted user input used in log entries.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "LogForging" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  class HtmlSanitizer extends Sanitizer {
    HtmlSanitizer() { this.asExpr() instanceof HtmlSanitizedExpr }
  }

  /**
   * An argument to a call to a method on a logger class.
   */
  class LogForgingLogMessageSink extends Sink, LogMessageSink { }

  /**
   * An argument to a call to a method on a trace class.
   */
  class LogForgingTraceMessageSink extends Sink, TraceMessageSink { }

  /**
   * A call to String replace or remove that is considered to sanitize replaced string.
   */
  class StringReplaceSanitizer extends Sanitizer {
    StringReplaceSanitizer() {
      exists(Method m |
        exists(SystemStringClass s | m = s.getReplaceMethod() or m = s.getRemoveMethod())
        or
        m = any(SystemTextRegularExpressionsRegexClass r).getAReplaceMethod()
      |
        this.asExpr() = m.getACall()
      )
    }
  }

  private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

  private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
}
