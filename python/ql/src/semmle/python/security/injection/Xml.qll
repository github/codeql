/**
 * Provides class and predicates to track external data that
 * may represent malicious XML objects.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.injection.Deserialization

private ModuleObject xmlElementTreeModule() { result.getName() = "xml.etree.ElementTree" }

private ModuleObject xmlMiniDomModule() { result.getName() = "xml.dom.minidom" }

private ModuleObject xmlPullDomModule() { result.getName() = "xml.dom.pulldom" }

private ModuleObject xmlSaxModule() { result.getName() = "xml.sax" }

private class ExpatParser extends TaintKind {
  ExpatParser() { this = "expat.parser" }
}

private FunctionObject expatCreateParseFunction() {
  result = ModuleObject::named("xml.parsers.expat").attr("ParserCreate")
}

private class ExpatCreateParser extends TaintSource {
  ExpatCreateParser() { expatCreateParseFunction().getACall() = this }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExpatParser }

  string toString() { result = "expat.create.parser" }
}

private FunctionObject xmlFromString() {
  result = xmlElementTreeModule().attr("fromstring")
  or
  result = xmlMiniDomModule().attr("parseString")
  or
  result = xmlPullDomModule().attr("parseString")
  or
  result = xmlSaxModule().attr("parseString")
}

/** A (potentially) malicious XML string. */
class ExternalXmlString extends ExternalStringKind {
  ExternalXmlString() { this = "external xml encoded object" }
}

/**
 * A call to an XML library function that is potentially vulnerable to a
 * specially crafted XML string.
 */
class XmlLoadNode extends DeserializationSink {
  override string toString() { result = "xml.load vulnerability" }

  XmlLoadNode() {
    exists(CallNode call | call.getAnArg() = this |
      xmlFromString().getACall() = call or
      any(ExpatParser parser).taints(call.getFunction().(AttrNode).getObject("Parse"))
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalXmlString }
}
