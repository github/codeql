/**
 * Provides a taint-tracking configuration for reasoning about cross-site scripting
 * (XSS) vulnerabilities.
 */

import csharp
private import XSSSinks
private import semmle.code.csharp.security.Sanitizers
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.dataflow.DataFlow2
private import semmle.code.csharp.dataflow.TaintTracking2

/**
 * Holds if there is tainted flow from `source` to `sink` that may lead to a
 * cross-site scripting (XSS) vulnerability, with `message`
 * providing a description of the source.
 * This is the main predicate to use in XSS queries.
 */
predicate xssFlow(XssNode source, XssNode sink, string message) {
  // standard taint-tracking
  exists(
    TaintTrackingConfiguration c, DataFlow2::PathNode sourceNode, DataFlow2::PathNode sinkNode
  |
    sourceNode = source.asDataFlowNode() and
    sinkNode = sink.asDataFlowNode() and
    c.hasFlowPath(sourceNode, sinkNode) and
    message =
      "is written to HTML or JavaScript" +
        any(string explanation |
          if exists(sinkNode.getNode().(Sink).explanation())
          then explanation = ": " + sinkNode.getNode().(Sink).explanation() + "."
          else explanation = "."
        )
  )
  or
  // flow entirely within ASP inline code
  source = sink and
  source.asAspInlineMember().getMember() instanceof AspNetQueryStringMember and
  message = "is a remote source accessed inline in an ASPX page."
}

/**
 * Provides the query predicates needed to include a graph in a path-problem query.
 */
module PathGraph {
  /** Holds if `(pred,succ)` is an edge in the graph of data flow path explanations. */
  query predicate edges(XssNode pred, XssNode succ) {
    exists(DataFlow2::PathNode a, DataFlow2::PathNode b | DataFlow2::PathGraph::edges(a, b) |
      pred.asDataFlowNode() = a and
      succ.asDataFlowNode() = b
    )
    or
    xssFlow(pred, succ, _) and
    pred instanceof XssAspNode
  }

  /** Holds if `n` is a node in the graph of data flow path explanations. */
  query predicate nodes(XssNode n, string key, string val) {
    DataFlow2::PathGraph::nodes(n.asDataFlowNode(), key, val)
    or
    xssFlow(n, n, _) and
    key = "semmle.label" and
    val = n.(XssAspNode).toString()
  }

  /**
   * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
   * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
   * `ret -> out` is summarized as the edge `arg -> out`.
   */
  query predicate subpaths(XssNode arg, XssNode par, XssNode ret, XssNode out) {
    DataFlow2::PathGraph::subpaths(arg.asDataFlowNode(), par.asDataFlowNode(), ret.asDataFlowNode(),
      out.asDataFlowNode())
  }
}

private newtype TXssNode =
  TXssDataFlowNode(DataFlow2::PathNode node) or
  TXssAspNode(AspInlineMember m)

/**
 * A flow node for tracking cross-site scripting (XSS) vulnerabilities.
 * Can be a standard data flow node (`XssDataFlowNode`)
 * or an ASP inline code element (`XssAspNode`).
 */
class XssNode extends TXssNode {
  /** Gets a textual representation of this node. */
  string toString() { none() }

  /** Gets the location of this node. */
  Location getLocation() { none() }

  /** Gets the data flow node corresponding to this node, if any. */
  DataFlow2::PathNode asDataFlowNode() { result = this.(XssDataFlowNode).getDataFlowNode() }

  /** Gets the ASP inline code element corresponding to this node, if any. */
  AspInlineMember asAspInlineMember() { result = this.(XssAspNode).getAspInlineMember() }
}

/** A data flow node, viewed as an XSS flow node. */
class XssDataFlowNode extends TXssDataFlowNode, XssNode {
  DataFlow2::PathNode node;

  XssDataFlowNode() { this = TXssDataFlowNode(node) }

  /** Gets the data flow node corresponding to this node. */
  DataFlow2::PathNode getDataFlowNode() { result = node }

  override string toString() { result = node.toString() }

  override Location getLocation() { result = node.getNode().getLocation() }
}

/** An ASP inline code element, viewed as an XSS flow node. */
class XssAspNode extends TXssAspNode, XssNode {
  AspInlineMember member;

  XssAspNode() { this = TXssAspNode(member) }

  /** Gets the ASP inline code element corresponding to this node. */
  AspInlineMember getAspInlineMember() { result = member }

  override string toString() { result = member.toString() }

  override Location getLocation() { result = member.getLocation() }
}

/**
 * A data flow source for cross-site scripting (XSS) vulnerabilities.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A sanitizer for cross-site scripting (XSS) vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for cross-site scripting (XSS) vulnerabilities.
 */
class TaintTrackingConfiguration extends TaintTracking2::Configuration {
  TaintTrackingConfiguration() { this = "XSSDataFlowConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/** A source of remote user input. */
private class RemoteSource extends Source {
  RemoteSource() { this instanceof RemoteFlowSource }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }

/** A call to an HTML encoder. */
private class HtmlEncodeSanitizer extends Sanitizer {
  HtmlEncodeSanitizer() { this.getExpr() instanceof HtmlSanitizedExpr }
}

/**
 * A call to a URL encoder.
 *
 * Url encoding is sufficient to sanitize for XSS because it ensures <, >, " and ' are escaped.
 * Furthermore, URL encoding is the only valid way to sanitize URLs that get inserted into HTML
 * attributes. Other uses of URL encoding may or may not produce the desired visual result, but
 * should be safe from XSS.
 */
private class UrlEncodeSanitizer extends Sanitizer {
  UrlEncodeSanitizer() { this.getExpr() instanceof UrlSanitizedExpr }
}

/**
 * A call to `Parse` for a numeric type, that causes the data to be considered
 * sanitized.
 */
private class NumericTypeParse extends Sanitizer {
  NumericTypeParse() {
    exists(Method m |
      m.getDeclaringType() instanceof IntegralType or
      m.getDeclaringType() instanceof FloatingPointType
    |
      m.hasName("Parse") and
      this.getExpr().(Call).getTarget() = m
    )
  }
}
