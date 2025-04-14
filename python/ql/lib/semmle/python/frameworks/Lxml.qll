/**
 * Provides classes modeling security-relevant aspects of the `lxml` PyPI package.
 *
 * See
 * - https://pypi.org/project/lxml/
 * - https://lxml.de/tutorial.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides classes modeling security-relevant aspects of the `lxml` PyPI package
 *
 * See
 * - https://pypi.org/project/lxml/
 * - https://lxml.de/tutorial.html
 */
module Lxml {
  /** Gets a reference to the `lxml.etree` module */
  API::Node etreeRef() {
    result = API::moduleImport("lxml").getMember("etree")
    or
    result = ModelOutput::getATypeNode("lxml.etree~Alias")
  }

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
    XPathClassCall() { this = etreeRef().getMember(["XPath", "ETXPath"]).getACall() }

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
      // TODO: lxml.etree.parseid(<text>)[0] will contain the root element from parsing <text>
      // but we don't really have a way to model that nicely.
      this = [Element::instance(), ElementTree::instance()].getMember("xpath").getACall()
    }

    override DataFlow::Node getXPath() { result in [this.getArg(0), this.getArgByName("_path")] }

    override string getName() { result = "lxml.etree" }
  }

  class XPathEvaluatorCall extends XML::XPathExecution::Range, DataFlow::CallCfgNode {
    XPathEvaluatorCall() { this = etreeRef().getMember("XPathEvaluator").getReturn().getACall() }

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
      LxmlParser() { this = etreeRef().getMember("XMLParser").getACall() }

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
      LxmlDefaultParser() { this = etreeRef().getMember("get_default_parser").getACall() }

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
   * - `lxml.etree.HTML`
   * - `lxml.etree.XML`
   * - `lxml.etree.XMLID`
   * - `lxml.etree.XMLDTDID`
   * - `lxml.etree.parse`
   * - `lxml.etree.parseid`
   *
   * See
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.fromstring
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.fromstringlist
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.HTML
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.XML
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.XMLID
   * - https://lxml.de/apidoc/lxml.etree.html#lxml.etree.XMLDTDID
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.parse
   * - https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.parseid
   */
  private class LxmlParsing extends DataFlow::CallCfgNode, XML::XmlParsing::Range {
    string functionName;

    LxmlParsing() {
      functionName in [
          "fromstring", "fromstringlist", "HTML", "XML", "XMLID", "XMLDTDID", "parse", "parseid"
        ] and
      this = etreeRef().getMember(functionName).getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // fromstring / HTML / XML / XMLID / XMLDTDID
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
      not exists(this.getParserArg()) and
      not functionName = "HTML"
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
    LxmlIterparseCall() { this = etreeRef().getMember("iterparse").getACall() }

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

  /** Provides models for the `lxml.etree.Element` class. */
  module Element {
    /** Gets a reference to the `Element` class. */
    API::Node classRef() { result = etreeRef().getMember(["Element", "_Element"]) }

    /**
     * A source of `lxml.etree.Element` instances, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Element::instance()` to get references to instances of `lxml.etree.Element` instances.
     */
    abstract class InstanceSource instanceof API::Node {
      /** Gets a textual representation of this element. */
      string toString() { result = super.toString() }
    }

    /** Gets a reference to an `lxml.etree.Element` instance. */
    API::Node instance() { result instanceof InstanceSource }

    /** An `Element` instantiated directly. */
    private class ElementInstance extends InstanceSource {
      ElementInstance() { this = classRef().getAnInstance() }
    }

    /** The result of a parse operation that returns an `Element`. */
    private class ParseResult extends InstanceSource {
      ParseResult() {
        // TODO: The XmlParser module does not currently use API graphs
        this =
          [
            etreeRef().getMember("XMLParser").getAnInstance(),
            etreeRef().getMember("get_default_parser").getReturn()
          ].getMember("close").getReturn()
        or
        // TODO: `XMLID`, `XMLDTDID`, `parseid` returns a tuple of which the first element is an `Element`.
        // `iterparse` returns an iterator of tuples, each of which has a second element that is an `Element`.
        this = etreeRef().getMember(["XML", "HTML", "fromstring", "fromstringlist"]).getReturn()
      }
    }

    /** A call to a method on an `Element` that returns another `Element`. */
    private class ElementMethod extends InstanceSource {
      ElementMethod() {
        // an Element is an iterator of Elements
        this = instance().getASubscript()
        or
        // methods that return an Element
        this = instance().getMember(["find", "getnext", "getprevious", "getparent"]).getReturn()
        or
        // methods that return an iterator of Elements
        this =
          instance()
              .getMember([
                  "cssselect", "findall", "getchildren", "getiterator", "iter", "iterancestors",
                  "iterdecendants", "iterchildren", "itersiblings", "iterfind", "xpath"
                ])
              .getReturn()
              .getASubscript()
      }
    }

    /** A call to a method on an `ElementTree` that returns an `Element`. */
    private class ElementTreeMethod extends InstanceSource {
      ElementTreeMethod() {
        this = ElementTree::instance().getMember(["getroot", "find"]).getReturn()
        or
        this =
          ElementTree::instance()
              .getMember(["findall", "getiterator", "iter", "iterfind", "xpath"])
              .getReturn()
              .getASubscript()
      }
    }

    /**
     * An additional taint step from an `Element` instance.
     * See https://lxml.de/apidoc/lxml.etree.html#lxml.etree.ElementBase.
     */
    private class ElementTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        exists(DataFlow::MethodCallNode call |
          nodeTo = call and instance().asSource().flowsTo(nodeFrom)
        |
          call.calls(nodeFrom,
            // We consider a node to be tainted if there could be taint anywhere in the element tree;
            // so sibling nodes (e.g. `getnext`) are also tainted.
            // This ensures nodes like `elem[0].getnext()` are tracked.
            [
              "cssselect", "find", "findall", "findtext", "get", "getchildren", "getiterator",
              "getnext", "getparent", "getprevious", "getroottree", "items", "iter",
              "iterancestors", "iterchildren", "iterdescendants", "itersiblings", "iterfind",
              "itertext", "keys", "values", "xpath"
            ])
        )
        or
        exists(DataFlow::AttrRead attr | nodeTo = attr and instance().asSource().flowsTo(nodeFrom) |
          attr.accesses(nodeFrom, ["attrib", "base", "nsmap", "prefix", "tag", "tail", "text"])
        )
      }
    }
  }

  /** Provides models for the `lxml.etree.ElementTree` class. */
  module ElementTree {
    /** Gets a reference to the `ElementTree` class. */
    API::Node classRef() { result = etreeRef().getMember(["ElementTree", "_ElementTree"]) }

    /**
     * A source of `lxml.etree.ElementTree` instances; extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `ElementTree::instance()` to get references to instances of `lxml.etree.ElementTree` instances.
     */
    abstract class InstanceSource instanceof API::Node {
      /** Gets a textual representation of this element. */
      string toString() { result = super.toString() }
    }

    /** Gets a reference to an `lxml.etree.ElementTree` instance. */
    API::Node instance() { result instanceof InstanceSource }

    /** An `ElementTree` instantiated directly. */
    private class ElementTreeInstance extends InstanceSource {
      ElementTreeInstance() { this = classRef().getAnInstance() }
    }

    /** The result of a parse operation that returns an `ElementTree`. */
    private class ParseResult extends InstanceSource {
      ParseResult() { this = etreeRef().getMember("parse").getReturn() }
    }

    /** A call to a method on an `Element` that returns another `Element`. */
    private class ElementMethod extends InstanceSource {
      ElementMethod() { this = Element::instance().getMember("getroottree").getReturn() }
    }

    /** An additional taint step from an `ElementTree` instance. See https://lxml.de/apidoc/lxml.etree.html#lxml.etree._ElementTree */
    private class ElementTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        exists(DataFlow::MethodCallNode call |
          nodeTo = call and instance().asSource().flowsTo(nodeFrom)
        |
          call.calls(nodeFrom,
            [
              "find", "findall", "findtext", "get", "getiterator", "getroot", "iter", "iterfind",
              "xpath"
            ])
        )
        or
        exists(DataFlow::AttrRead attr | nodeTo = attr and instance().asSource().flowsTo(nodeFrom) |
          attr.accesses(nodeFrom, "docinfo")
        )
      }
    }
  }

  /** A call to serialise xml to a string */
  private class XmlEncoding extends Encoding::Range, DataFlow::CallCfgNode {
    XmlEncoding() {
      this = etreeRef().getMember(["tostring", "tostringlist", "tounicode"]).getACall()
    }

    override DataFlow::Node getAnInput() {
      result = [this.getArg(0), this.getArgByName("element_or_tree")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "XML" }
  }
  // TODO: ElementTree.write can write to a file-like object; should that be a flow step?
  // It also can accept a filepath which could be a path injection sink.
}
