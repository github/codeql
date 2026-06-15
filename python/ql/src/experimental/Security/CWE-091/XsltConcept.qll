private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

/**
 * A data-flow node that constructs a XSLT transformer.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `TemplateConstruction::Range` instead.
 */
class XsltConstruction extends DataFlow::Node instanceof XsltConstruction::Range {
  /** Gets the argument that specifies the XSLT transformer. */
  DataFlow::Node getXsltArg() { result = super.getXsltArg() }
}

/** Provides a class for modeling new system-command execution APIs. */
module XsltConstruction {
  /**
   * A data-flow node that constructs a XSLT transformer.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `XsltConstruction` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the XSLT transformer. */
    abstract DataFlow::Node getXsltArg();
  }
}

/**
 * A data-flow node that executes a XSLT transformer.
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `TemplateConstruction::Range` instead.
 */
class XsltExecution extends DataFlow::Node instanceof XsltExecution::Range {
  /** Gets the argument that specifies the XSLT transformer. */
  DataFlow::Node getXsltArg() { result = super.getXsltArg() }
}

/** Provides a class for modeling new system-command execution APIs. */
module XsltExecution {
  /**
   * A data-flow node that executes a XSLT transformer.
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `XsltExecution` instead.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the argument that specifies the XSLT transformer. */
    abstract DataFlow::Node getXsltArg();
  }
}

// -----------------------------------------------------------------------------
/**
 * A call to `lxml.etree.XSLT`.
 *
 * ```py
 * from lxml import etree
 * xslt_tree = etree.parse(...)
 * doc = etree.parse(...)
 * transform = etree.XSLT(xslt_tree)
 * result = transform(doc)
 * ```
 */
class LxmlEtreeXsltCall extends XsltConstruction::Range, API::CallNode {
  LxmlEtreeXsltCall() {
    this = API::moduleImport("lxml").getMember("etree").getMember("XSLT").getACall()
  }

  override DataFlow::Node getXsltArg() { result = this.getParameter(0, "xslt_input").asSink() }
}

/**
 * A call to `.xslt` on an lxml ElementTree object.
 *
 * ```py
 * from lxml import etree
 * xslt_tree = etree.parse(...)
 * doc = etree.parse(...)
 * result = doc.xslt(xslt_tree)
 * ```
 */
class XsltAttributeCall extends XsltExecution::Range, API::CallNode {
  XsltAttributeCall() { this = elementTreeConstruction(_).getReturn().getMember("xslt").getACall() }

  override DataFlow::Node getXsltArg() { result = this.getParameter(0, "_xslt").asSink() }
}

// -----------------------------------------------------------------------------
API::CallNode elementTreeConstruction(DataFlow::Node inputArg) {
  // TODO: If we could, would be nice to model this as flow-summaries. But I'm not sure if we actually can :thinking:
  // see https://lxml.de/api/lxml.etree-module.html#fromstring
  result = API::moduleImport("lxml").getMember("etree").getMember("fromstring").getACall() and
  inputArg = result.getParameter(0, "text").asSink()
  or
  // see https://lxml.de/api/lxml.etree-module.html#fromstringlist
  result = API::moduleImport("lxml").getMember("etree").getMember("fromstringlist").getACall() and
  inputArg = result.getParameter(0, "strings").asSink()
  or
  // TODO: technically we should treat parse differently, since it takes a file as argument
  // see https://lxml.de/api/lxml.etree-module.html#parse
  result = API::moduleImport("lxml").getMember("etree").getMember("parse").getACall() and
  inputArg = result.getParameter(0, "source").asSink()
  or
  // see https://lxml.de/api/lxml.etree-module.html#XML
  result = API::moduleImport("lxml").getMember("etree").getMember("XML").getACall() and
  inputArg = result.getParameter(0, "text").asSink()
}
