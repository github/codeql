/**
 * Provides modeling for `libxml`, an XML library for Ruby.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for `libxml`, an XML library for Ruby.
 */
module Libxml {
  /**
   * Flow summary for `libxml`. Wraps a string, parsing it as an XML document.
   */
  private class XMLSummary extends SummarizedCallable {
    XMLSummary() { this = "LibXML::XML" }

    override MethodCall getACall() { result = any(LibXmlRubyXmlParserCall c).asExpr().getExpr() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call that parses XML. */
  private class LibXmlRubyXmlParserCall extends DataFlow::CallNode {
    LibXmlRubyXmlParserCall() {
      this =
        [API::getTopLevelMember("LibXML").getMember("XML"), API::getTopLevelMember("XML")]
            .getMember(["Document", "Parser"])
            .getAMethodCall(["file", "io", "string"])
    }

    DataFlow::Node getInput() { result = this.getArgument(0) }
  }

  /** Execution of a XPath statement. */
  private class LibXmlXPathExecution extends XPathExecution::Range, DataFlow::CallNode {
    LibXmlXPathExecution() {
      exists(LibXmlRubyXmlParserCall parserCall |
        this = parserCall.getAMethodCall(["find", "find_first"])
      )
    }

    override DataFlow::Node getXPath() { result = this.getArgument(0) }
  }
}
