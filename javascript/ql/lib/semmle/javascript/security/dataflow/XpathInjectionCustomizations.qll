/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * untrusted user input used in XPath expression, as well as extension
 * points for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.DOM

module XpathInjection {
  /**
   * A data flow source for untrusted user input used in XPath expression.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for untrusted user input used in XPath expression.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for untrusted user input used in XPath expression.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for XPath injection. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /**
   * The `expression` argument to `xpath.parse` or `xpath.select` (and similar) from
   * the `xpath` or `xpath.js` npm packages, considered as a flow sink for XPath injection.
   */
  class XpathParseSelectSink extends Sink {
    XpathParseSelectSink() {
      // both packages appear to expose the same API
      exists(string xpath | xpath = "xpath" or xpath = "xpath.js" |
        // `xpath.parse`, `xpath.select` and `xpath.select1` all interpret their first
        // argument as an XPath expression
        exists(string m | m = "parse" or m = "select" or m = "select1" |
          this = DataFlow::moduleMember(xpath, m).getACall().getArgument(0)
        )
        or
        // `xpath.useNamespaces` returns a function that interprets its first argument
        // as an XPath expression
        this = DataFlow::moduleMember(xpath, "useNamespaces").getACall().getACall().getArgument(0)
      )
    }
  }

  /** A part of the document URL, considered as a flow source for XPath injection. */
  class DocumentUrlSource extends Source {
    DocumentUrlSource() { this = DOM::locationSource() }
  }

  /**
   * The `expression` argument to `document.evaluate` or `document.createExpression`,
   * considered as a flow sink for XPath injection.
   */
  class DomXpathSink extends Sink {
    DomXpathSink() {
      exists(string m | m = "evaluate" or m = "createExpression" |
        this = DOM::documentRef().getAMethodCall(m).getArgument(0)
      )
    }
  }
}
