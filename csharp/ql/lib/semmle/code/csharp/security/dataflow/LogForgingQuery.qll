/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in log entries.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.text.RegularExpressions
private import semmle.code.csharp.security.Sanitizers
private import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink
private import semmle.code.csharp.dataflow.internal.ExternalFlow

/**
 * A data flow source for untrusted user input used in log entries.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for untrusted user input used in log entries.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for untrusted user input used in log entries.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for untrusted user input used in log entries.
 */
private module LogForgingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for untrusted user input used in log entries.
 */
module LogForging = TaintTracking::Global<LogForgingConfig>;

/** A source supported by the current threat model. */
private class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

private class HtmlSanitizer extends Sanitizer {
  HtmlSanitizer() { this.asExpr() instanceof HtmlSanitizedExpr }
}

/**
 * An argument to a call to a method on a logger class.
 */
private class LogForgingLogMessageSink extends Sink, LogMessageSink { }

/**
 * An argument to a call to a method on a trace class.
 */
private class LogForgingTraceMessageSink extends Sink, TraceMessageSink { }

/** Log Forging sinks defined through Models as Data. */
private class ExternalLoggingExprSink extends Sink {
  ExternalLoggingExprSink() { sinkNode(this, "log-injection") }
}

/**
 * A call to String replace or remove that is considered to sanitize replaced string.
 */
private class StringReplaceSanitizer extends Sanitizer {
  StringReplaceSanitizer() {
    exists(Method m |
      exists(SystemStringClass s |
        m = s.getReplaceMethod() or m = s.getRemoveMethod() or m = s.getReplaceLineEndingsMethod()
      )
      or
      m = any(SystemTextRegularExpressionsRegexClass r).getAReplaceMethod()
    |
      this.asExpr() = m.getACall()
    )
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
