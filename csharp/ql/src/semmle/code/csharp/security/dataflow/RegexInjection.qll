/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used to construct
 * regular expressions.
 */

import csharp

module RegexInjection {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.system.text.RegularExpressions
  import semmle.code.csharp.security.Sanitizers

  /**
   * A data flow source for untrusted user input used to construct regular expressions.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for untrusted user input used to construct regular expressions.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for untrusted user input used to construct regular expressions.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A taint-tracking configuration for untrusted user input used to construct regular expressions.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "RegexInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

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
}
