/**
 * Provides modeling for `rexml`, an XML toolkit for Ruby.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for `rexml`, an XML toolkit for Ruby.
 */
module Rexml {
  /**
   * Flow summary for `REXML::Document.new()`. This method wraps a string, parsing it as an XML document.
   */
  private class XmlSummary extends SummarizedCallable {
    XmlSummary() { this = "REXML::Document.new()" }

    override MethodCall getACall() { result = any(RexmlParserCall c).asExpr().getExpr() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call to `REXML::Document.new`, considered as a XML parsing. */
  private class RexmlParserCall extends XmlParserCall::Range, DataFlow::CallNode {
    RexmlParserCall() {
      this = API::getTopLevelMember("REXML").getMember("Document").getAnInstantiation()
    }

    override DataFlow::Node getInput() { result = this.getArgument(0) }

    /** No option for parsing */
    override predicate externalEntitiesEnabled() { none() }
  }

  /** Execution of a XPath statement. */
  private class RexmlXPathExecution extends XPathExecution::Range, DataFlow::CallNode {
    RexmlXPathExecution() {
      this =
        [API::getTopLevelMember("REXML").getMember("XPath"), API::getTopLevelMember("XPath")]
            .getAMethodCall(["each", "first", "match"])
    }

    override DataFlow::Node getXPath() { result = this.getArgument(1) }
  }
}
