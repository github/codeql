/**
 * Provides class and predicates to track external data that
 * may represent malicious xpath query objects.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.security.TaintTracking
import semmle.python.web.HttpRequest

/** Models Xpath Injection related classes and functions */
module XpathInjection {
  /** Returns a class value which refers to `lxml.etree` */
  Value etree() { result = Value::named("lxml.etree") }

  /** A generic taint sink that is vulnerable to Xpath injection. */
  abstract class XpathInjectionSink extends TaintSink { }

  /**
   * A Sink representing an argument to the `etree.Xpath` call.
   *
   *    from lxml import etree
   *    root = etree.XML("<xmlContent>")
   *    find_text = etree.XPath("`sink`")
   */
  private class EtreeXpathArgument extends XpathInjectionSink {
    override string toString() { result = "lxml.etree.Xpath" }

    EtreeXpathArgument() {
      exists(CallNode call, AttrNode atr |
        atr = etree().getAReference().getASuccessor() and
        atr.getName() = "XPath" and
        atr = call.getFunction()
      |
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
      exists(CallNode call, AttrNode atr |
        atr = etree().getAReference().getASuccessor() and
        atr.getName() = "ETXPath" and
        atr = call.getFunction()
      |
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
      exists(CallNode parseCall, AttrNode parse, string s |
        parse = etree().getAReference().getASuccessor() and
        parse.getName() = "parse" and
        parse = parseCall.getFunction() and
        exists(CallNode xpathCall, AttrNode xpath |
          xpath = parseCall.getASuccessor*() and
          xpath.getName() = "xpath" and
          xpath = xpathCall.getFunction() and
          s = xpath.getName() and
          this = xpathCall.getArg(0)
        )
      )
    }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
  }
}
