/**
 * Provides classes modeling security-relevant aspects of the `libxml2` PyPI package.
 *
 * See
 * - https://pypi.org/project/libxml2-python3/
 * - http://xmlsoft.org/python.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling security-relevant aspects of the `libxml2` PyPI package
 *
 * See
 * - https://pypi.org/project/libxml2-python3/
 * - http://xmlsoft.org/python.html
 */
private module Libxml2 {
  /**
   * A call to the `xpathEval` method of a parsed document.
   *
   *    import libxml2
   *    tree = libxml2.parseFile("file.xml")
   *    r = tree.xpathEval('`sink`')
   *
   * See http://xmlsoft.org/python.html
   */
  class XpathEvalCall extends XML::XPathExecution::Range, DataFlow::CallCfgNode {
    XpathEvalCall() {
      this =
        API::moduleImport("libxml2")
            .getMember("parseFile")
            .getReturn()
            .getMember("xpathEval")
            .getACall()
    }

    override DataFlow::Node getXPath() { result = this.getArg(0) }

    override string getName() { result = "libxml2" }
  }
}
