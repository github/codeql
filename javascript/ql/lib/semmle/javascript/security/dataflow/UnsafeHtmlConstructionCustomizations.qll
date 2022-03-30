/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe HTML constructed from library input, as well as extension points
 * for adding your own.
 */

import javascript

/**
 * Module containing sources, sinks, and sanitizers for unsafe HTML constructed from library input.
 */
module UnsafeHtmlConstruction {
  private import semmle.javascript.security.dataflow.DomBasedXssCustomizations::DomBasedXss as DomBasedXss
  private import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin as UnsafeJQueryPlugin
  private import semmle.javascript.PackageExports as Exports

  /**
   * A source for unsafe HTML constructed from library input.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A parameter of an exported function, seen as a source for usnafe HTML constructed from input.
   */
  class ExternalInputSource extends Source, DataFlow::ParameterNode {
    ExternalInputSource() {
      this = Exports::getALibraryInputParameter() and
      // An AMD-style module sometimes loads the jQuery library in a way which looks like library input.
      not this = JQuery::dollarSource()
    }
  }

  /**
   * A jQuery plugin options object, seen as a source for unsafe HTML constructed from input.
   */
  class JQueryPluginOptionsAsSource extends Source {
    JQueryPluginOptionsAsSource() { this instanceof UnsafeJQueryPlugin::JQueryPluginOptions }
  }

  /**
   * A sink for unsafe HTML constructed from library input.
   * This sink transforms its input into a value that can cause XSS if it ends up in a XSS sink.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the kind of vulnerability to report in the alert message.
     *
     * Defaults to `Cross-site scripting`, but may be overriden for sinks
     * that do not allow script injection, but injection of other undesirable HTML elements.
     */
    abstract string getVulnerabilityKind();

    /**
     * Gets the XSS sink that this transformed input ends up in.
     */
    abstract DataFlow::Node getSink();

    /**
     * Gets a string describing the transformation that this sink represents.
     */
    abstract string describe();
  }

  /**
   * A sink for `js/html-constructed-from-input` that constructs some HTML where
   * that HTML is later used in `xssSink`.
   */
  abstract class XssSink extends Sink {
    DomBasedXss::Sink xssSink;

    final override string getVulnerabilityKind() { result = xssSink.getVulnerabilityKind() }

    final override DomBasedXss::Sink getSink() { result = xssSink }
  }

  /**
   * Gets a dataflow node that flows to `sink` tracked by `t`.
   */
  private DataFlow::Node isUsedInXssSink(DataFlow::TypeBackTracker t, DomBasedXss::Sink sink) {
    t.start() and
    result = sink
    or
    exists(DataFlow::TypeBackTracker t2 | t = t2.smallstep(result, isUsedInXssSink(t2, sink)))
    or
    exists(DataFlow::TypeBackTracker t2 |
      t.continue() = t2 and
      domBasedTaintStep(result, isUsedInXssSink(t2, sink))
    )
  }

  /**
   * Gets a dataflow node that flows to `sink`.
   */
  DataFlow::Node isUsedInXssSink(DomBasedXss::Sink sink) {
    result = isUsedInXssSink(DataFlow::TypeBackTracker::end(), sink)
  }

  /**
   * Holds if there is a taint step from `pred` to `succ` for DOM strings/nodes.
   * These steps are mostly relevant for DOM nodes that are created by an XML parser.
   */
  predicate domBasedTaintStep(DataFlow::Node pred, DataFlow::SourceNode succ) {
    // node.appendChild(newChild) and similar
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = ["insertBefore", "replaceChild", "appendChild"]
    |
      pred = call.getArgument(0) and
      succ = [call.getReceiver().getALocalSource(), call]
    )
    or
    // element.{prepend,append}(node) and similar
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = ["prepend", "append", "replaceWith", "replaceChildren"]
    |
      pred = call.getAnArgument() and
      succ = call.getReceiver().getALocalSource()
    )
    or
    // node.insertAdjacentElement("location", newChild)
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "insertAdjacentElement" |
      pred = call.getArgument(1) and
      succ = call.getReceiver().getALocalSource()
    )
    or
    // clone = node.cloneNode()
    exists(DataFlow::MethodCallNode cloneNode | cloneNode.getMethodName() = "cloneNode" |
      pred = cloneNode.getReceiver() and
      succ = cloneNode
    )
    or
    // var succ = pred.documentElement;
    // documentElement is the root element of the document, and childNodes is the list of all children
    exists(DataFlow::PropRead read | read.getPropertyName() = ["documentElement", "childNodes"] |
      pred = read.getBase() and
      succ = read
    )
  }

  /**
   * A string-concatenation of HTML, where the result is used as an XSS sink.
   */
  class HtmlConcatenationSink extends XssSink, StringOps::HtmlConcatenationLeaf {
    HtmlConcatenationSink() { isUsedInXssSink(xssSink) = this.getRoot() }

    override string describe() { result = "HTML construction" }
  }

  /** DEPRECATED: Alias for HtmlConcatenationSink */
  deprecated class HTMLConcatenationSink = HtmlConcatenationSink;

  /**
   * A string parsed as XML, which is later used in an XSS sink.
   */
  class XmlParsedSink extends XssSink {
    XmlParsedSink() {
      exists(XML::ParserInvocation parser |
        this.asExpr() = parser.getSourceArgument() and
        isUsedInXssSink(xssSink) = parser.getAResult()
      )
    }

    override string describe() { result = "XML parsing" }
  }

  /** DEPRECATED: Alias for XmlParsedSink */
  deprecated class XMLParsedSink = XmlParsedSink;

  /**
   * A string rendered as markdown, where the rendering preserves HTML.
   */
  class MarkdownSink extends XssSink {
    MarkdownSink() {
      exists(DataFlow::Node pred, DataFlow::Node succ, Markdown::MarkdownStep step |
        step.step(pred, succ) and
        step.preservesHtml() and
        this = pred and
        succ = isUsedInXssSink(xssSink)
      )
    }

    override string describe() { result = "Markdown rendering" }
  }
}
