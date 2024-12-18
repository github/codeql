/**
 * Provides classes modeling security-relevant aspects of the `opml` PyPI package.
 *
 * See
 * - https://pypi.org/project/opml/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling security-relevant aspects of the `opml` PyPI package
 *
 * See
 * - https://pypi.org/project/opml/
 */
private module Opml {
  /**
   * A call to the `xpath` method of a parsed document.
   *
   *    import opml
   *    root = opml.from_string(file(XML_DB).read())
   *    find_text = root.xpath("`sink`")
   */
  private class XPathCall extends XML::XPathExecution::Range, DataFlow::CallCfgNode {
    XPathCall() {
      exists(API::Node parseResult |
        parseResult = API::moduleImport("opml").getMember(["parse", "from_string"]).getReturn()
      |
        this = parseResult.getMember("xpath").getACall()
      )
    }

    override DataFlow::Node getXPath() { result = this.getArg(0) }

    override string getName() { result = "opml" }
  }

  /**
   * A call to either of:
   * - `opml.parse`
   * - `opml.from_string`
   */
  private class OpmlParsing extends DataFlow::CallCfgNode, XML::XmlParsing::Range {
    OpmlParsing() {
      this = API::moduleImport("opml").getMember(["parse", "from_string"]).getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    DataFlow::Node getParserArg() { none() }

    /**
     * The same as `Lxml::LxmlParsing::vulnerableTo`, because `opml` uses `lxml` for parsing.
     */
    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) { kind.isXxe() }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() { result = this }
  }
}
