/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used to construct
 * regular expressions.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.system.text.RegularExpressions
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for untrusted user input used to construct regular expressions.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for untrusted user input used to construct regular expressions.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for untrusted user input used to construct regular expressions.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for untrusted user input used to construct regular expressions.
 */
private module RegexInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for untrusted user input used to construct regular expressions.
 */
module RegexInjection = TaintTracking::Global<RegexInjectionConfig>;

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

/**
 * A `pattern` argument to a construction of a `Regex`.
 */
class RegexObjectCreationSink extends Sink {
  RegexObjectCreationSink() {
    exists(RegexOperation operation |
      this.getExpr() = operation.getPattern() and
      not operation.hasTimeout()
    )
  }
}

/** A call to `Regex.Escape` that sanitizes the user input for use in a regex. */
class RegexEscapeSanitizer extends Sanitizer {
  RegexEscapeSanitizer() {
    this.getExpr().(MethodCall).getTarget() =
      any(SystemTextRegularExpressionsRegexClass r).getAMethod("Escape")
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
