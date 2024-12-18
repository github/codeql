/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in dangerous
 * regular expression operations.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.system.text.RegularExpressions
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for untrusted user input used in dangerous regular expression operations.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for untrusted user input used in dangerous regular expression operations.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for untrusted user input used in dangerous regular expression operations.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for untrusted user input used in dangerous regular expression operations.
 */
private module ReDoSConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for untrusted user input used in dangerous regular expression operations.
 */
module ReDoS = TaintTracking::Global<ReDoSConfig>;

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

/**
 * An expression that represents a regular expression with potential exponential behavior.
 */
predicate isExponentialRegex(StringLiteral s) {
  /*
   * Detect three variants of a common pattern that leads to exponential blow-up.
   */

  // Example: ([a-z]+.)+
  s.getValue().regexpMatch(".*\\([^()*+\\]]+\\]?(\\*|\\+)\\.?\\)(\\*|\\+).*")
  or
  // Example: (([a-z])?([a-z]+.))+
  s.getValue()
      .regexpMatch(".*\\((\\([^()]+\\)\\?)?\\([^()*+\\]]+\\]?(\\*|\\+)\\.?\\)\\)(\\*|\\+).*")
  or
  // Example: (([a-z])+.)+
  s.getValue().regexpMatch(".*\\(\\([^()*+\\]]+\\]?\\)(\\*|\\+)\\.?\\)(\\*|\\+).*")
}

/**
 * A data flow configuration for tracking exponential worst case time regular expression string
 * literals to the pattern argument of a regex.
 */
private module ExponentialRegexDataFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node s) { isExponentialRegex(s.asExpr()) }

  predicate isSink(DataFlow::Node s) { s.asExpr() = any(RegexOperation c).getPattern() }
}

module ExponentialRegexDataFlow = DataFlow::Global<ExponentialRegexDataFlowConfig>;

/**
 * An expression passed as the `input` to a call to a `Regex` method, where the regex appears to
 * have exponential behavior.
 */
class ExponentialRegexSink extends DataFlow::ExprNode, Sink {
  ExponentialRegexSink() {
    exists(RegexOperation regexOperation |
      // Exponential regex flows to the pattern argument
      ExponentialRegexDataFlow::flow(_, DataFlow::exprNode(regexOperation.getPattern()))
    |
      // This is used as an input for this pattern
      this.getExpr() = regexOperation.getInput() and
      // No timeouts
      not regexOperation.hasTimeout()
    )
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
