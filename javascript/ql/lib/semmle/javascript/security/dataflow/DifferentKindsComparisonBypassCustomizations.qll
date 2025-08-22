/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * comparisons that relies on different kinds of HTTP request data, as
 * well as extension points for adding your own.
 */

import javascript

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
   * A HTTP request input that is suspicious to compare with another HTTP request input of a different kind.
   */
  class RequestInputComparisonSource extends Source instanceof Http::RequestInputAccess {
    override predicate isSuspiciousToCompareWith(Source other) {
      super.getKind() != other.(RequestInputComparisonSource).getInput().getKind()
    }

    /**
     * Gets the HTTP request input of this source.
     */
    private Http::RequestInputAccess getInput() { result = this }
  }

  /**
   * A data flow sink for a potential suspicious comparisons.
   */
  private class ComparisonOperandSink extends Sink {
    ComparisonOperandSink() { this.asExpr() = any(Comparison c).getAnOperand() }
  }
}
