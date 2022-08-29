/**
 * Provides class and predicates to track external data that
 * may represent malicious XSLT query objects.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.HttpRequest

/** Models XSLT Injection related classes and functions */
module XsltInjection {
  /** Returns a class value which refers to `lxml.etree` */
  Value etree() { result = Value::named("lxml.etree") }

  /** A generic taint sink that is vulnerable to XSLT injection. */
  abstract class XsltInjectionSink extends TaintSink { }

  /** DEPRECATED: Alias for XsltInjectionSink */
  deprecated class XSLTInjectionSink = XsltInjectionSink;

  /**
   * A kind of "taint", representing an untrusted XML string
   */
  deprecated private class ExternalXmlStringKind extends ExternalStringKind {
    ExternalXmlStringKind() { this = "etree.XML string" }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
      etreeXml(fromnode, tonode) and result instanceof ExternalXmlKind
      or
      etreeFromStringList(fromnode, tonode) and result instanceof ExternalXmlKind
      or
      etreeFromString(fromnode, tonode) and result instanceof ExternalXmlKind
    }
  }

  /**
   * A kind of "taint", representing a XML encoded  string
   */
  class ExternalXmlKind extends TaintKind {
    ExternalXmlKind() { this = "lxml etree xml" }
  }

  private predicate etreeXml(ControlFlowNode fromnode, CallNode tonode) {
    // etree.XML("<xmlContent>")
    exists(CallNode call | call.getFunction().(AttrNode).getObject("XML").pointsTo(etree()) |
      call.getArg(0) = fromnode and
      call = tonode
    )
  }

  private predicate etreeFromString(ControlFlowNode fromnode, CallNode tonode) {
    // etree.fromstring(text, parser=None)
    exists(CallNode call | call.getFunction().(AttrNode).getObject("fromstring").pointsTo(etree()) |
      call.getArg(0) = fromnode and
      call = tonode
    )
  }

  private predicate etreeFromStringList(ControlFlowNode fromnode, CallNode tonode) {
    // etree.fromstringlist(strings, parser=None)
    exists(CallNode call |
      call.getFunction().(AttrNode).getObject("fromstringlist").pointsTo(etree())
    |
      call.getArg(0) = fromnode and
      call = tonode
    )
  }

  /**
   * A Sink representing an argument to the `etree.XSLT` call.
   *
   *    from lxml import etree
   *    root = etree.XML("<xmlContent>")
   *    find_text = etree.XSLT("`sink`")
   */
  private class EtreeXsltArgument extends XsltInjectionSink {
    override string toString() { result = "lxml.etree.XSLT" }

    EtreeXsltArgument() {
      exists(CallNode call | call.getFunction().(AttrNode).getObject("XSLT").pointsTo(etree()) |
        call.getArg(0) = this
      )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalXmlKind }
  }

  /**
   * A Sink representing an argument to the `XSLT` call to a parsed xml document.
   *
   *    from lxml import etree
   *    from io import StringIO
   *    `sink` = etree.XML(xsltQuery)
   *    tree = etree.parse(f)
   *    result_tree = tree.xslt(`sink`)
   */
  private class ParseXsltArgument extends XsltInjectionSink {
    override string toString() { result = "lxml.etree.parse.xslt" }

    ParseXsltArgument() {
      exists(
        CallNode parseCall, CallNode xsltCall, ControlFlowNode obj, Variable var, AssignStmt assign
      |
        parseCall.getFunction().(AttrNode).getObject("parse").pointsTo(etree()) and
        assign.getValue().(Call).getAFlowNode() = parseCall and
        xsltCall.getFunction().(AttrNode).getObject("xslt") = obj and
        var.getAUse() = obj and
        assign.getATarget() = var.getAStore() and
        xsltCall.getArg(0) = this
      )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalXmlKind }
  }
}

/** DEPRECATED: Alias for XsltInjection */
deprecated module XSLTInjection = XsltInjection;
