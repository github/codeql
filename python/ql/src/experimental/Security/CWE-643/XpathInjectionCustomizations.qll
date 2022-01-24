/**
 * Provides class and predicates to track external data that
 * may represent malicious xpath query objects.
 *
 * This module is intended to be imported into a taint-tracking query.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/** Models Xpath Injection related classes and functions */
module XpathInjection {
  /**
   * A data flow source for "XPath injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "XPath injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "XPath injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "XPath injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /** Returns an API node referring to `lxml.etree` */
  API::Node etree() { result = API::moduleImport("lxml").getMember("etree") }

  /** Returns an API node referring to `lxml.etree` */
  API::Node etreeFromString() { result = etree().getMember("fromstring") }

  /** Returns an API node referring to `lxml.etree.parse` */
  API::Node etreeParse() { result = etree().getMember("parse") }

  /** Returns an API node referring to `lxml.etree.parse` */
  API::Node libxml2parseFile() { result = API::moduleImport("libxml2").getMember("parseFile") }

  /**
   * A Sink representing an argument to `etree.XPath` or `etree.ETXPath` call.
   *
   *    from lxml import etree
   *    root = etree.XML("<xmlContent>")
   *    find_text = etree.XPath("`sink`")
   *    find_text = etree.ETXPath("`sink`")
   */
  private class EtreeXpathArgument extends Sink {
    EtreeXpathArgument() { this = etree().getMember(["XPath", "ETXPath"]).getACall().getArg(0) }
  }

  /**
   * A Sink representing an argument to the `etree.XPath` call.
   *
   *    from lxml import etree
   *    root =  etree.fromstring(file(XML_DB).read(), XMLParser())
   *    find_text = root.xpath("`sink`")
   */
  private class EtreeFromstringXpathArgument extends Sink {
    EtreeFromstringXpathArgument() {
      this = etreeFromString().getReturn().getMember("xpath").getACall().getArg(0)
    }
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
  private class ParseXpathArgument extends Sink {
    ParseXpathArgument() { this = etreeParse().getReturn().getMember("xpath").getACall().getArg(0) }
  }

  /**
   * A Sink representing an argument to the `xpathEval` call to a parsed libxml2 document.
   *
   *    import libxml2
   *    tree = libxml2.parseFile("file.xml")
   *    r = tree.xpathEval('`sink`')
   */
  private class ParseFileXpathEvalArgument extends Sink {
    ParseFileXpathEvalArgument() {
      this = libxml2parseFile().getReturn().getMember("xpathEval").getACall().getArg(0)
    }
  }
}
