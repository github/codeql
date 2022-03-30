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

deprecated private ModuleObject xmlElementTreeModule() {
  result.getName() = "xml.etree.ElementTree"
}

deprecated private ModuleObject xmlMiniDomModule() { result.getName() = "xml.dom.minidom" }

deprecated private ModuleObject xmlPullDomModule() { result.getName() = "xml.dom.pulldom" }

deprecated private ModuleObject xmlSaxModule() { result.getName() = "xml.sax" }

deprecated private class ExpatParser extends TaintKind {
  ExpatParser() { this = "expat.parser" }
}

deprecated private FunctionObject expatCreateParseFunction() {
  result = ModuleObject::named("xml.parsers.expat").attr("ParserCreate")
}

deprecated private class ExpatCreateParser extends TaintSource {
  ExpatCreateParser() { expatCreateParseFunction().getACall() = this }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExpatParser }

  override string toString() { result = "expat.create.parser" }
}

deprecated private FunctionObject xmlFromString() {
  result = xmlElementTreeModule().attr("fromstring")
  or
  result = xmlMiniDomModule().attr("parseString")
  or
  result = xmlPullDomModule().attr("parseString")
  or
  result = xmlSaxModule().attr("parseString")
}

/** A (potentially) malicious XML string. */
deprecated class ExternalXmlString extends ExternalStringKind {
  ExternalXmlString() { this = "external xml encoded object" }
}

/**
 * A call to an XML library function that is potentially vulnerable to a
 * specially crafted XML string.
 */
deprecated class XmlLoadNode extends DeserializationSink {
  override string toString() { result = "xml.load vulnerability" }

  XmlLoadNode() {
    exists(CallNode call | call.getAnArg() = this |
      xmlFromString().getACall() = call or
      any(ExpatParser parser).taints(call.getFunction().(AttrNode).getObject("Parse"))
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalXmlString }
}
