/**
 * Provides classes for working with XPath-related concepts such as XPath expressions.
 */
overlay[local?]
module;

import go
import semmle.go.dataflow.ExternalFlow

/** Provides classes for working with XPath-related APIs. */
module XPath {
  /**
   * A data-flow node whose string value is interpreted as (part of) an XPath expression.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `XPath::XPathExpressionString::Range` instead.
   */
  class XPathExpressionString extends DataFlow::Node instanceof XPathExpressionString::Range { }

  /** Provides classes for working with XPath expression strings. */
  module XPathExpressionString {
    /**
     * A data-flow node whose string value is interpreted as (part of) an XPath expression.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `XPath::XPathExpressionString` instead.
     */
    abstract class Range extends DataFlow::Node { }

    private class ExternalXPathExpressionString extends Range {
      ExternalXPathExpressionString() { sinkNode(this, "xpath-injection") }
    }
  }

  /** A sanitizer for XPath injection. */
  abstract class Sanitizer extends DataFlow::Node { }

  private class ExternalSanitizer extends Sanitizer {
    ExternalSanitizer() { barrierNode(this, "xpath-injection") }
  }
}
