/**
 * Provides classes modeling security-relevant aspects of the `xmltodict` PyPI package.
 *
 * See
 * - https://pypi.org/project/xmltodict/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling security-relevant aspects of the `xmltodict` PyPI package
 *
 * See
 * - https://pypi.org/project/xmltodict/
 */
private module Xmltodict {
  /**
   * A call to `xmltodict.parse`.
   */
  private class XMLtoDictParsing extends API::CallNode, XML::XmlParsing::Range {
    XMLtoDictParsing() { this = API::moduleImport("xmltodict").getMember("parse").getACall() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("xml_input")]
    }

    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      kind.isXmlBomb() and
      this.getKeywordParameter("disable_entities").getAValueReachingSink().asExpr() = any(False f)
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() { result = this }
  }
}
