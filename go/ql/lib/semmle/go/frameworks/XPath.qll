/**
 * Provides classes for working with XPath-related concepts such as XPath expressions.
 */

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

    private class DefaultXPathExpressionString extends Range {
      DefaultXPathExpressionString() { sinkNode(this, "xpath-injection") }
    }
  }
}

/**
 * DEPRECATED
 *
 * Provides classes for working with the [xmlpath](https://gopkg.in/xmlpath.v2) package.
 */
deprecated module XmlPath {
  /**
   * DEPRECATED
   *
   * Gets the package name `github.com/go-xmlpath/xmlpath` or `gopkg.in/xmlpath`.
   */
  deprecated string packagePath() {
    result =
      package([
          "github.com/go-xmlpath/xmlpath", "gopkg.in/xmlpath", "github.com/crankycoder/xmlpath",
          "launchpad.net/xmlpath", "github.com/masterzen/xmlpath",
          "github.com/going/toolkit/xmlpath", "gopkg.in/go-xmlpath/xmlpath"
        ], "")
  }
}
