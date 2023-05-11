/**
 * Provides modeling for `nokogiri`, an XML library for Ruby.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for `nokogiri`, an XML library for Ruby.
 */
module Nokogiri {
  /**
   * Flow summary for `nokogiri`. Wraps a string, parsing it as an XML document.
   */
  private class XMLSummary extends SummarizedCallable {
    XMLSummary() { this = "Nokogiri::XML.parse" }

    override MethodCall getACall() { result = any(NokogiriXmlParserCall p).asExpr().getExpr() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call that parses XML. */
  private class NokogiriXmlParserCall extends DataFlow::CallNode {
    NokogiriXmlParserCall() {
      this =
        [
          API::getTopLevelMember("Nokogiri").getMember("XML"),
          API::getTopLevelMember("Nokogiri").getMember("XML").getMember("Document"),
          API::getTopLevelMember("Nokogiri")
              .getMember("XML")
              .getMember("SAX")
              .getMember("Parser")
              .getInstance()
        ].getAMethodCall("parse")
    }

    DataFlow::Node getInput() { result = this.getArgument(0) }
  }

  /** Execution of a XPath statement. */
  private class NokogiriXPathExecution extends XPathExecution::Range, DataFlow::CallNode {
    NokogiriXPathExecution() {
      exists(NokogiriXmlParserCall parserCall |
        this = parserCall.getAMethodCall(["xpath", "at_xpath", "search", "at"])
      )
    }

    override DataFlow::Node getXPath() { result = this.getArgument(0) }
  }
}
