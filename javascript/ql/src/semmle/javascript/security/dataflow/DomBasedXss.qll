/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
import semmle.javascript.frameworks.jQuery

module DomBasedXss {
  /**
   * A data flow source for XSS vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for XSS vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for XSS vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "DomBasedXss" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      exists (PropAccess pacc | pacc = node.asExpr() |
        isSafeLocationProperty(pacc) or
        // `$(location.hash)` is a fairly common and safe idiom
        // (because `location.hash` always starts with `#`),
        // so we mark `hash` as safe for the purposes of this query
        pacc.getPropertyName() = "hash"
      ) or
      node instanceof Sanitizer
    }
  }

  /** A source of remote user input, considered as a flow source for DOM-based XSS. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An access of the URL of this page, or of the referrer to this page.
   */
  class LocationSource extends Source, DataFlow::ValueNode {
    LocationSource() {
      isDocumentURL(astNode)
    }
  }

  /**
   * An expression whose value is interpreted as HTML
   * and may be inserted into the DOM through a library.
   */
  class LibrarySink extends Sink, DataFlow::ValueNode {
    LibrarySink() {
      // call to a jQuery method that interprets its argument as HTML
      exists(JQueryMethodCall call | call.interpretsArgumentAsHtml(astNode) |
        // either the argument is always interpreted as HTML
        not call.interpretsArgumentAsSelector(astNode)
        or
        // or it doesn't start with something other than `<`, and so at least
        // _may_ be interpreted as HTML
        not exists (DataFlow::Node prefix, string strval |
          isPrefixOfJQueryHtmlString(astNode, prefix) and
          strval = prefix.asExpr().getStringValue() and
          not strval.regexpMatch("\\s*<.*")
        )
      )
      or
      // call to an Angular method that interprets its argument as HTML
      any(AngularJS::AngularJSCall call).interpretsArgumentAsHtml(this.asExpr())
    }
  }

  /**
   * Holds if `prefix` is a prefix of `htmlString`, which may be intepreted as
   * HTML by a jQuery method.
   */
  private predicate isPrefixOfJQueryHtmlString(Expr htmlString, DataFlow::Node prefix) {
    any(JQueryMethodCall call).interpretsArgumentAsHtml(htmlString) and
    prefix = htmlString.flow()
    or
    exists (DataFlow::Node pred | isPrefixOfJQueryHtmlString(htmlString, pred) |
      prefix = StringConcatenation::getFirstOperand(pred)
      or
      prefix = pred.getAPredecessor()
    )
  }

  /**
   * An expression whose value is interpreted as HTML or CSS
   * and may be inserted into the DOM.
   */
  class DomSink extends Sink {
    DomSink() {
      // Call to a DOM function that inserts its argument into the DOM
      any(DomMethodCallExpr call).interpretsArgumentsAsHTML(this.asExpr())
      or
      // Assignment to a dangerous DOM property
      exists (DomPropWriteNode pw |
        pw.interpretsValueAsHTML() and
        this = DataFlow::valueNode(pw.getRhs())
      )
      or
      // `html` or `source.html` properties of React Native `WebView`
      exists (ReactNative::WebViewElement webView, DataFlow::SourceNode source |
        source = webView or
        source = webView.getAPropertyWrite("source").getRhs().getALocalSource() |
        this = source.getAPropertyWrite("html").getRhs()
      )
    }
  }

  /**
   * An expression whose value is interpreted as HTML by a DOMParser.
   */
  class DomParserSink extends Sink {
    DomParserSink() {
      exists (DataFlow::GlobalVarRefNode domParser |
        domParser.getName() = "DOMParser" and
        this = domParser.getAnInstantiation().getAMethodCall("parseFromString").getArgument(0)
      )
    }
  }

  /**
   * A React `dangerouslySetInnerHTML` attribute, viewed as an XSS sink.
   *
   * Any write to the `__html` property of an object assigned to this attribute
   * is considered an XSS sink.
   */
  class DangerouslySetInnerHtmlSink extends Sink, DataFlow::ValueNode {
    DangerouslySetInnerHtmlSink() {
      exists (DataFlow::Node danger, DataFlow::SourceNode valueSrc |
        exists (JSXAttribute attr |
          attr.getName() = "dangerouslySetInnerHTML" and
          attr.getValue() = danger.asExpr()
        )
        or
        exists (ReactElementDefinition def, DataFlow::ObjectLiteralNode props |
          props.flowsTo(def.getProps()) and
          props.hasPropertyWrite("dangerouslySetInnerHTML", danger)
        ) |
        valueSrc.flowsTo(danger) and
        valueSrc.hasPropertyWrite("__html", this)
      )
    }
  }

}

/** DEPRECATED: Use `DomBasedXss::Source` instead. */
deprecated class XssSource = DomBasedXss::Source;

/** DEPRECATED: Use `DomBasedXss::Sink` instead. */
deprecated class XssSink = DomBasedXss::Sink;

/** DEPRECATED: Use `DomBasedXss::Sanitizer` instead. */
deprecated class XssSanitizer = DomBasedXss::Sanitizer;

/** DEPRECATED: Use `DomBasedXss::Configuration` instead. */
deprecated class XssDataFlowConfiguration = DomBasedXss::Configuration;
