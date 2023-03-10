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
  // ---------------------------------------------------------------------------
  // XPath
  // ---------------------------------------------------------------------------
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
      exists(API::Node parseResult |
        parseResult =
          API::moduleImport("lxml")
              .getMember("etree")
              .getMember(["parse", "fromstring", "fromstringlist", "HTML", "XML"])
              .getReturn()
        or
        // TODO: lxml.etree.parseid(<text>)[0] will contain the root element from parsing <text>
        // but we don't really have a way to model that nicely.
        parseResult =
          API::moduleImport("lxml")
              .getMember("etree")
              .getMember("XMLParser")
              .getReturn()
              .getMember("close")
              .getReturn()
      |
        this = parseResult.getMember("xpath").getACall()
      )
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

  // ---------------------------------------------------------------------------
  // Parsing
  // ---------------------------------------------------------------------------
  /**
   * Provides models for `lxml.etree` parsers.
   *
   * See https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.XMLParser
   */
  module XmlParser {
    /**
     * A source of instances of `lxml.etree` parsers, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `XmlParser::instance()` to get references to instances of `lxml.etree` parsers.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode {
      /** Holds if this instance is vulnerable to `kind`. */
      abstract predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind);
    }

    /**
     * A call to `lxml.etree.XMLParser`.
     *
     * See https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.XMLParser
     */
    private class LxmlParser extends InstanceSource, API::CallNode {
      LxmlParser() {
        this = API::moduleImport("lxml").getMember("etree").getMember("XMLParser").getACall()
      }

      // NOTE: it's not possible to change settings of a parser after constructing it
      override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
        kind.isXxe() and
        (
          // resolve_entities has default True
          not exists(this.getArgByName("resolve_entities"))
          or
          this.getKeywordParameter("resolve_entities").getAValueReachingSink().asExpr() =
            any(True t)
        )
        or
        kind.isXmlBomb() and
        this.getKeywordParameter("huge_tree").getAValueReachingSink().asExpr() = any(True t) and
        not this.getKeywordParameter("resolve_entities").getAValueReachingSink().asExpr() =
          any(False t)
        or
        kind.isDtdRetrieval() and
        this.getKeywordParameter("load_dtd").getAValueReachingSink().asExpr() = any(True t) and
        this.getKeywordParameter("no_network").getAValueReachingSink().asExpr() = any(False t)
      }
    }

    /**
     * A call to `lxml.etree.get_default_parser`.
     *
     * See https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.get_default_parser
     */
    private class LxmlDefaultParser extends InstanceSource, DataFlow::CallCfgNode {
      LxmlDefaultParser() {
        this =
          API::moduleImport("lxml").getMember("etree").getMember("get_default_parser").getACall()
      }

      override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
        // as highlighted by
        // https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.XMLParser
        // by default XXE is allow. so as long as the default parser has not been
        // overridden, the result is also vuln to XXE.
        kind.isXxe()
        // TODO: take into account that you can override the default parser with `lxml.etree.set_default_parser`.
      }
    }

    /** Gets a reference to an `lxml.etree` parsers instance, with origin in `origin` */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t, InstanceSource origin) {
      t.start() and
      result = origin
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2, origin).track(t2, t))
    }

    /** Gets a reference to an `lxml.etree` parsers instance, with origin in `origin` */
    DataFlow::Node instance(InstanceSource origin) {
      instance(DataFlow::TypeTracker::end(), origin).flowsTo(result)
    }

    /** Gets a reference to an `lxml.etree` parser instance, that is vulnerable to `kind`. */
    DataFlow::Node instanceVulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      exists(InstanceSource origin | result = instance(origin) and origin.vulnerableTo(kind))
    }

    /**
     * A call to the `feed` method of an `lxml` parser.
     */
    private class LxmlParserFeedCall extends DataFlow::MethodCallNode, XML::XmlParsing::Range {
      LxmlParserFeedCall() { this.calls(instance(_), "feed") }

      override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

      override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
        this.calls(instanceVulnerableTo(kind), "feed")
      }

      override predicate mayExecuteInput() { none() }

      override DataFlow::Node getOutput() {
        exists(DataFlow::Node objRef |
          DataFlow::localFlow(this.getObject(), objRef) and
          result.(DataFlow::MethodCallNode).calls(objRef, "close")
        )
      }
    }
  }

  /**
   * A call to either of:
   * - `lxml.etree.fromstring`
   * - `lxml.etree.fromstringlist`
   * - `lxml.etree.XML`
   * - `lxml.etree.XMLID`
   * - `lxml.etree.parse`
   * - `lxml.etree.parseid`
   *
   * See
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.fromstring
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.fromstringlist
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.XML
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.XMLID
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.parse
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.parseid
   */
  private class LxmlParsing extends DataFlow::CallCfgNode, XML::XmlParsing::Range {
    string functionName;

    LxmlParsing() {
      functionName in ["fromstring", "fromstringlist", "XML", "XMLID", "parse", "parseid"] and
      this = API::moduleImport("lxml").getMember("etree").getMember(functionName).getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // fromstring / XML / XMLID
          this.getArgByName("text"),
          // fromstringlist
          this.getArgByName("strings"),
          // parse / parseid
          this.getArgByName("source"),
        ]
    }

    DataFlow::Node getParserArg() { result in [this.getArg(1), this.getArgByName("parser")] }

    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      this.getParserArg() = XmlParser::instanceVulnerableTo(kind)
      or
      kind.isXxe() and
      not exists(this.getParserArg())
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() {
      // Note: for `parseid`/XMLID the result of the call is a tuple with `(root, dict)`, so
      // maybe we should not just say that the entire tuple is the decoding output... my
      // gut feeling is that THIS instance doesn't matter too much, but that it would be
      // nice to be able to do this in general. (this is a problem for both `lxml.etree`
      // and `xml.etree`)
      result = this
    }
  }

  /**
   * A call to `lxml.etree.ElementTree.parse` or `lxml.etree.ElementTree.parseid`, which
   * takes either a filename or a file-like object as argument. To capture the filename
   * for path-injection, we have this subclass.
   *
   * See
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.parse
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.parseid
   */
  private class FileAccessFromLxmlParsing extends LxmlParsing, FileSystemAccess::Range {
    FileAccessFromLxmlParsing() {
      functionName in ["parse", "parseid"]
      // I considered whether we should try to reduce FPs from people passing file-like
      // objects, which will not be a file system access (and couldn't cause a
      // path-injection).
      //
      // I suppose that once we have proper flow-summary support for file-like objects,
      // we can make the XXE/XML-bomb sinks allow an access-path, while the
      // path-injection sink wouldn't, and then we will not end up with such FPs.
    }

    override DataFlow::Node getAPathArgument() { result = this.getAnInput() }
  }

  /**
   * A call to `lxml.etree.iterparse`
   *
   * See
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.iterparse
   */
  private class LxmlIterparseCall extends API::CallNode, XML::XmlParsing::Range,
    FileSystemAccess::Range
  {
    LxmlIterparseCall() {
      this = API::moduleImport("lxml").getMember("etree").getMember("iterparse").getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("source")] }

    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      // note that there is no `resolve_entities` argument, so it's not possible to turn off XXE :O
      kind.isXxe()
      or
      kind.isXmlBomb() and
      this.getKeywordParameter("huge_tree").getAValueReachingSink().asExpr() = any(True t)
      or
      kind.isDtdRetrieval() and
      this.getKeywordParameter("load_dtd").getAValueReachingSink().asExpr() = any(True t) and
      this.getKeywordParameter("no_network").getAValueReachingSink().asExpr() = any(False t)
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() { result = this }

    override DataFlow::Node getAPathArgument() { result = this.getAnInput() }
  }
}
