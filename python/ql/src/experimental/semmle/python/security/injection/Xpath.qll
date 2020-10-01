/**
 * Provides class and predicates to track external data that
 * may represent malicious xpath query objects.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.HttpRequest

/** Models Xpath Injection related classes and functions */
module XpathInjection {
  /** Returns a class value which refers to `lxml.etree` */
  Value etree() { result = Value::named("lxml.etree") }

  /** Returns a class value which refers to `lxml.etree` */
  Value libxml2parseFile() { result = Value::named("libxml2.parseFile") }

  /** A generic taint sink that is vulnerable to Xpath injection. */
  abstract class XpathInjectionSink extends TaintSink { }

  /**
   * A Sink representing an argument to the `etree.XPath` call.
   *
   *    from lxml import etree
   *    root = etree.XML("<xmlContent>")
   *    find_text = etree.XPath("`sink`")
   */
  private class EtreeXpathArgument extends XpathInjectionSink {
    override string toString() { result = "lxml.etree.XPath" }

    EtreeXpathArgument() {
      exists(CallNode call | call.getFunction().(AttrNode).getObject("XPath").pointsTo(etree()) |
        call.getArg(0) = this
      )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
  }

  /**
   * A Sink representing an argument to the `etree.EtXpath` call.
   *
   *    from lxml import etree
   *    root = etree.XML("<xmlContent>")
   *    find_text = etree.EtXPath("`sink`")
   */
  private class EtreeETXpathArgument extends XpathInjectionSink {
    override string toString() { result = "lxml.etree.ETXpath" }

    EtreeETXpathArgument() {
      exists(CallNode call | call.getFunction().(AttrNode).getObject("ETXPath").pointsTo(etree()) |
        call.getArg(0) = this
      )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
  }

  /**
   * A Sink representing an argument to the `xpath` call to a parsed xml document.
   *
   *    from lxml import etree
   *    from io import StringIO
   *    f = StringIO('<foo><bar></bar></foo>')
   *    tree = etree.parse(f)
   *    r = tree.xpath('`sink`')
   */
  private class ParseXpathArgument extends XpathInjectionSink {
    override string toString() { result = "lxml.etree.parse.xpath" }

    ParseXpathArgument() {
      exists(
        CallNode parseCall, CallNode xpathCall, ControlFlowNode obj, Variable var, AssignStmt assign
      |
        parseCall.getFunction().(AttrNode).getObject("parse").pointsTo(etree()) and
        assign.getValue().(Call).getAFlowNode() = parseCall and
        xpathCall.getFunction().(AttrNode).getObject("xpath") = obj and
        var.getAUse() = obj and
        assign.getATarget() = var.getAStore() and
        xpathCall.getArg(0) = this
      )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
  }

  /**
   * A Sink representing an argument to the `xpathEval` call to a parsed libxml2 document.
   *
   *    import libxml2
   *    tree = libxml2.parseFile("file.xml")
   *    r = tree.xpathEval('`sink`')
   */
  private class ParseFileXpathEvalArgument extends XpathInjectionSink {
    override string toString() { result = "libxml2.parseFile.xpathEval" }

    ParseFileXpathEvalArgument() {
      exists(
        CallNode parseCall, CallNode xpathCall, ControlFlowNode obj, Variable var, AssignStmt assign
      |
        parseCall.getFunction().(AttrNode).pointsTo(libxml2parseFile()) and
        assign.getValue().(Call).getAFlowNode() = parseCall and
        xpathCall.getFunction().(AttrNode).getObject("xpathEval") = obj and
        var.getAUse() = obj and
        assign.getATarget() = var.getAStore() and
        xpathCall.getArg(0) = this
      )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
  }
}
