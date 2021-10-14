/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * comparisons that relies on different kinds of HTTP request data, as
 * well as extension points for adding your own.
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
}
