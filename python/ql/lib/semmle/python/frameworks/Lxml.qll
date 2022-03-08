/**
 * Provides classes modeling security-relevant aspects of the `lxml` PyPI package.
 *
 * See
 * - https://pypi.org/project/lxml/
 * - https://lxml.de/tutorial.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling security-relevant aspects of the `lxml` PyPI package
 *
 * See
 * - https://pypi.org/project/lxml/
 * - https://lxml.de/tutorial.html
 */
private module Lxml {
  /**
   * A class constructor compiling an XPath expression.
   *
   *    from lxml import etree
   *    find_text = etree.XPath("`sink`")
   *    find_text = etree.ETXPath("`sink`")
   *
   * See
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.XPath
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.ETXPath
   */
  private class XPathClassCall extends XML::XPathConstruction::Range, DataFlow::CallCfgNode {
    XPathClassCall() {
      this = API::moduleImport("lxml").getMember("etree").getMember(["XPath", "ETXPath"]).getACall()
    }

    override DataFlow::Node getXPath() { result in [this.getArg(0), this.getArgByName("path")] }

    override string getName() { result = "lxml.etree" }
  }

  /**
   * A call to the `xpath` method of a parsed document.
   *
   *    from lxml import etree
   *    root =  etree.fromstring(file(XML_DB).read(), XMLParser())
   *    find_text = root.xpath("`sink`")
   *
   * See https://lxml.de/apidoc/lxml.etree.html#lxml.etree._ElementTree.xpath
   * as well as
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.parse
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.fromstring
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.fromstringlist
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.HTML
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.XML
   */
  class XPathCall extends XML::XPathExecution::Range, DataFlow::CallCfgNode {
    XPathCall() {
      this =
        API::moduleImport("lxml")
            .getMember("etree")
            .getMember(["parse", "fromstring", "fromstringlist", "HTML", "XML"])
            .getReturn()
            .getMember("xpath")
            .getACall()
    }

    override DataFlow::Node getXPath() { result in [this.getArg(0), this.getArgByName("_path")] }

    override string getName() { result = "lxml.etree" }
  }

  class XPathEvaluatorCall extends XML::XPathExecution::Range, DataFlow::CallCfgNode {
    XPathEvaluatorCall() {
      this =
        API::moduleImport("lxml")
            .getMember("etree")
            .getMember("XPathEvaluator")
            .getReturn()
            .getACall()
    }

    override DataFlow::Node getXPath() { result = this.getArg(0) }

    override string getName() { result = "lxml.etree" }
  }
}
