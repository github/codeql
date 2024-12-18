/**
 * Provides a taint-tracking configuration for reasoning about cross-site scripting
 * (XSS) vulnerabilities.
 */

import csharp
private import XSSSinks
private import semmle.code.csharp.security.Sanitizers
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources

/**
 * Holds if there is tainted flow from `source` to `sink` that may lead to a
 * cross-site scripting (XSS) vulnerability, with `message`
 * providing a description of the source.
 * This is the main predicate to use in XSS queries.
 */
predicate xssFlow(XssNode source, XssNode sink, string message) {
  // standard taint-tracking
  exists(XssTracking::PathNode sourceNode, XssTracking::PathNode sinkNode |
    sourceNode = source.asDataFlowNode() and
    sinkNode = sink.asDataFlowNode() and
    XssTracking::flowPath(sourceNode, sinkNode) and
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
  query predicate edges(XssNode pred, XssNode succ, string key, string val) {
    exists(XssTracking::PathNode a, XssTracking::PathNode b |
      XssTracking::PathGraph::edges(a, b, key, val)
    |
      pred.asDataFlowNode() = a and
      succ.asDataFlowNode() = b
    )
    or
    xssFlow(pred, succ, _) and
    pred instanceof XssAspNode and
    key = "provenance" and
    val = ""
  }

  /** Holds if `n` is a node in the graph of data flow path explanations. */
  query predicate nodes(XssNode n, string key, string val) {
    XssTracking::PathGraph::nodes(n.asDataFlowNode(), key, val)
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
    XssTracking::PathGraph::subpaths(arg.asDataFlowNode(), par.asDataFlowNode(),
      ret.asDataFlowNode(), out.asDataFlowNode())
  }
}

private newtype TXssNode =
  TXssDataFlowNode(XssTracking::PathNode node) or
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

  /**
   * Gets the data flow node corresponding to this node, if any.
   */
  XssTracking::PathNode asDataFlowNode() { result = this.(XssDataFlowNode).getDataFlowNode() }

  /** Gets the ASP inline code element corresponding to this node, if any. */
  AspInlineMember asAspInlineMember() { result = this.(XssAspNode).getAspInlineMember() }
}

/**
 * A data flow node, viewed as an XSS flow node.
 */
class XssDataFlowNode extends TXssDataFlowNode, XssNode {
  XssTracking::PathNode node;

  XssDataFlowNode() { this = TXssDataFlowNode(node) }

  /** Gets the data flow node corresponding to this node. */
  XssTracking::PathNode getDataFlowNode() { result = node }

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
module XssTrackingConfig implements DataFlow::ConfigSig {
  /**
   * Holds if `source` is a relevant data flow source.
   */
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  /**
   * Holds if `sink` is a relevant data flow sink.
   */
  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  /**
   * Holds if data flow through `node` is prohibited. This completely removes
   * `node` from the data flow graph.
   */
  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

module XssTracking = TaintTracking::Global<XssTrackingConfig>;

/** A source supported by the current threat model. */
private class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

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
