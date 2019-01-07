/**
 * Provides classes for reasoning about comparisons that relies on different kinds of HTTP request data.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module DifferentKindsComparisonBypass {
  /**
   * A data flow source for comparisons that relies on different kinds of HTTP request data.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Holds if it suspicious to compare this source with `other`.
     */
    abstract predicate isSuspiciousToCompareWith(Source other);
  }

  /**
   * A data flow sink for comparisons that relies on different kinds of HTTP request data.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for comparisons that relies on different kinds of HTTP request data.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint tracking configuration for comparisons that relies on different kinds of HTTP request data.
   */
  private class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "DifferentKindsComparisonBypass" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  /**
   * A HTTP request input that is suspicious to compare with another HTTP request input of a different kind.
   */
  class RequestInputComparisonSource extends Source {
    HTTP::RequestInputAccess input;

    RequestInputComparisonSource() { input = this }

    override predicate isSuspiciousToCompareWith(Source other) {
      input.getKind() != other.(RequestInputComparisonSource).getInput().getKind()
    }

    /**
     * Gets the HTTP request input of this source.
     */
    private HTTP::RequestInputAccess getInput() { result = input }
  }

  /**
   * A data flow sink for a potential suspicious comparisons.
   */
  private class ComparisonOperandSink extends Sink {
    ComparisonOperandSink() { asExpr() = any(Comparison c).getAnOperand() }
  }

  /**
   * A comparison that relies on different kinds of HTTP request data.
   */
  class DifferentKindsComparison extends Comparison {
    Source lSource;

    Source rSource;

    DifferentKindsComparison() {
      exists(Configuration cfg |
        cfg.hasFlow(lSource, DataFlow::valueNode(getLeftOperand())) and
        cfg.hasFlow(rSource, DataFlow::valueNode(getRightOperand())) and
        lSource.isSuspiciousToCompareWith(rSource)
      )
    }

    /** Gets the left operand source of this comparison. */
    Source getLSource() { result = lSource }

    /** Gets the right operand source of this comparison. */
    Source getRSource() { result = rSource }
  }
}
