/**
 * Provides classes modeling security-relevant aspects of the `xmltodict` PyPI package.
 * See https://pypi.org/project/xmltodict/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `xmltodict` PyPI package.
 * See https://pypi.org/project/xmltodict/
 */
private module XmlToDictModel {
  /** Gets a reference to the `xmltodict` module. */
  API::Node xmltodict() { result = API::moduleImport("xmltodict") }

  /**
   * A call to `xmltodict.parse`
   * See https://github.com/martinblech/xmltodict/blob/ae19c452ca000bf243bfc16274c060bf3bf7cf51/xmltodict.py#L198
   */
  private class XmlToDictParseCall extends Decoding::Range, DataFlow::CallCfgNode {
    XmlToDictParseCall() { this = xmltodict().getMember("parse").getACall() }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "XML" }
  }
}
