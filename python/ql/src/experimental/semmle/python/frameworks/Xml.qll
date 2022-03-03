/**
 * Provides class and predicates to track external data that
 * may represent malicious XML objects.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module XmlEtree {
  /**
   * Provides models for `xml.etree` parsers
   *
   * See
   * - https://docs.python.org/3.10/library/xml.etree.elementtree.html#xml.etree.ElementTree.XMLParser
   * - https://docs.python.org/3.10/library/xml.etree.elementtree.html#xml.etree.ElementTree.XMLPullParser
   */
  module XMLParser {
    /**
     * A source of instances of `xml.etree` parsers, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `XMLParser::instance()` to get references to instances of `xml.etree` parsers.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `xml.etree` parsers. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() {
        this =
          API::moduleImport("xml")
              .getMember("etree")
              .getMember("ElementTree")
              .getMember("XMLParser")
              .getACall()
        or
        this =
          API::moduleImport("xml")
              .getMember("etree")
              .getMember("ElementTree")
              .getMember("XMLPullParser")
              .getACall()
      }
    }

    /** Gets a reference to an `xml.etree` parser instance. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an `xml.etree` parser instance. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * A call to the `feed` method of an `xml.etree` parser.
     */
    private class XMLEtreeParserFeedCall extends DataFlow::MethodCallNode, XML::XMLParsing::Range {
      XMLEtreeParserFeedCall() { this.calls(instance(), "feed") }

      override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

      override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
        kind.isBillionLaughs() or kind.isQuadraticBlowup()
      }
    }
  }

  /**
   * A call to either of:
   * - `xml.etree.ElementTree.fromstring`
   * - `xml.etree.ElementTree.fromstringlist`
   * - `xml.etree.ElementTree.XML`
   * - `xml.etree.ElementTree.XMLID`
   * - `xml.etree.ElementTree.parse`
   * - `xml.etree.ElementTree.iterparse`
   */
  private class XMLEtreeParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    XMLEtreeParsing() {
      this =
        API::moduleImport("xml")
            .getMember("etree")
            .getMember("ElementTree")
            .getMember(["fromstring", "fromstringlist", "XML", "XMLID", "parse", "iterparse"])
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // fromstring / XML / XMLID
          this.getArgByName("text"),
          // fromstringlist
          this.getArgByName("sequence"),
          // parse / iterparse
          this.getArgByName("source"),
        ]
    }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      // note: it does not matter what `xml.etree` parser you are using, you cannot
      // change the security features anyway :|
      kind.isBillionLaughs() or kind.isQuadraticBlowup()
    }
  }
}

private module SaxBasedParsing {
  /**
   * A call to the `setFeature` method on a XML sax parser.
   *
   * See https://docs.python.org/3.10/library/xml.sax.reader.html#xml.sax.xmlreader.XMLReader.setFeature
   */
  class SaxParserSetFeatureCall extends DataFlow::MethodCallNode {
    SaxParserSetFeatureCall() {
      this =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("make_parser")
            .getReturn()
            .getMember("setFeature")
            .getACall()
    }

    // The keyword argument names does not match documentation. I checked (with Python
    // 3.9.5) that the names used here actually works.
    DataFlow::Node getFeatureArg() { result in [this.getArg(0), this.getArgByName("name")] }

    DataFlow::Node getStateArg() { result in [this.getArg(1), this.getArgByName("state")] }
  }

  /** Gets a back-reference to the `setFeature` state argument `arg`. */
  private DataFlow::TypeTrackingNode saxParserSetFeatureStateArgBacktracker(
    DataFlow::TypeBackTracker t, DataFlow::Node arg
  ) {
    t.start() and
    arg = any(SaxParserSetFeatureCall c).getStateArg() and
    result = arg.getALocalSource()
    or
    exists(DataFlow::TypeBackTracker t2 |
      result = saxParserSetFeatureStateArgBacktracker(t2, arg).backtrack(t2, t)
    )
  }

  /** Gets a back-reference to the `setFeature` state argument `arg`. */
  DataFlow::LocalSourceNode saxParserSetFeatureStateArgBacktracker(DataFlow::Node arg) {
    result = saxParserSetFeatureStateArgBacktracker(DataFlow::TypeBackTracker::end(), arg)
  }

  /** Gets a reference to a XML sax parser that has `feature_external_ges` turned on */
  private DataFlow::Node saxParserWithFeatureExternalGesTurnedOn(DataFlow::TypeTracker t) {
    t.start() and
    exists(SaxParserSetFeatureCall call |
      call.getFeatureArg() =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("handler")
            .getMember("feature_external_ges")
            .getAUse() and
      saxParserSetFeatureStateArgBacktracker(call.getStateArg())
          .asExpr()
          .(BooleanLiteral)
          .booleanValue() = true and
      result = call.getObject()
    )
    or
    exists(DataFlow::TypeTracker t2 |
      t = t2.smallstep(saxParserWithFeatureExternalGesTurnedOn(t2), result)
    ) and
    // take account of that we can set the feature to False, which makes the parser safe again
    not exists(SaxParserSetFeatureCall call |
      call.getObject() = result and
      call.getFeatureArg() =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("handler")
            .getMember("feature_external_ges")
            .getAUse() and
      saxParserSetFeatureStateArgBacktracker(call.getStateArg())
          .asExpr()
          .(BooleanLiteral)
          .booleanValue() = false
    )
  }

  /** Gets a reference to a XML sax parser that has been made unsafe for `kind`. */
  DataFlow::Node saxParserWithFeatureExternalGesTurnedOn() {
    result = saxParserWithFeatureExternalGesTurnedOn(DataFlow::TypeTracker::end())
  }

  /**
   * A call to the `parse` method on a SAX XML parser.
   */
  private class XMLSaxInstanceParsing extends DataFlow::MethodCallNode, XML::XMLParsing::Range {
    XMLSaxInstanceParsing() {
      this =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("make_parser")
            .getReturn()
            .getMember("parse")
            .getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("source")] }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      // always vuln to these
      (kind.isBillionLaughs() or kind.isQuadraticBlowup())
      or
      // can be vuln to other things if features has been turned on
      this.getObject() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
    }
  }

  /**
   * A call to either `parse` or `parseString` from `xml.sax` module.
   *
   * See:
   * - https://docs.python.org/3.10/library/xml.sax.html#xml.sax.parse
   * - https://docs.python.org/3.10/library/xml.sax.html#xml.sax.parseString
   */
  private class XMLSaxParsing extends DataFlow::MethodCallNode, XML::XMLParsing::Range {
    XMLSaxParsing() {
      this =
        API::moduleImport("xml").getMember("sax").getMember(["parse", "parseString"]).getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // parseString
          this.getArgByName("string"),
          // parse
          this.getArgByName("source"),
        ]
    }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      // always vuln to these
      (kind.isBillionLaughs() or kind.isQuadraticBlowup())
      or
      // can be vuln to other things if features has been turned on
      this.getObject() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
    }
  }

  /**
   * A call to the `parse` or `parseString` methods from `xml.dom.minidom` or `xml.dom.pulldom`.
   *
   * Both of these modules are based on SAX parsers.
   */
  private class XMLDomParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    XMLDomParsing() {
      this =
        API::moduleImport("xml")
            .getMember("dom")
            .getMember(["minidom", "pulldom"])
            .getMember(["parse", "parseString"])
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // parseString
          this.getArgByName("string"),
          // minidom.parse
          this.getArgByName("file"),
          // pulldom.parse
          this.getArgByName("stream_or_string"),
        ]
    }

    DataFlow::Node getParserArg() { result in [this.getArg(1), this.getArgByName("parser")] }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      this.getParserArg() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
      or
      (kind.isBillionLaughs() or kind.isQuadraticBlowup())
    }
  }
}

private module Lxml {
  /**
   * A call to `lxml.etree.get_default_parser`.
   *
   * See https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.get_default_parser
   */
  private class LXMLDefaultParser extends DataFlow::CallCfgNode, XML::XMLParser::Range {
    LXMLDefaultParser() {
      this = API::moduleImport("lxml").getMember("etree").getMember("get_default_parser").getACall()
    }

    override DataFlow::Node getAnInput() { none() }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      // as highlighted by
      // https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.XMLParser
      // by default XXE is allow. so as long as the default parser has not been
      // overridden, the result is also vuln to XXE.
      kind.isXxe()
      // TODO: take into account that you can override the default parser with `lxml.etree.get_default_parser`.
    }
  }

  /**
   * A call to `lxml.etree.XMLParser`.
   *
   * See https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.XMLParser
   */
  private class LXMLParser extends DataFlow::CallCfgNode, XML::XMLParser::Range {
    LXMLParser() {
      this = API::moduleImport("lxml").getMember("etree").getMember("XMLParser").getACall()
    }

    override DataFlow::Node getAnInput() { none() }

    // NOTE: it's not possible to change settings of a parser after constructing it
    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      kind.isXxe() and
      (
        // resolve_entities has default True
        not exists(this.getArgByName("resolve_entities"))
        or
        this.getArgByName("resolve_entities").getALocalSource().asExpr() = any(True t)
      )
      or
      (kind.isBillionLaughs() or kind.isQuadraticBlowup()) and
      this.getArgByName("huge_tree").getALocalSource().asExpr() = any(True t)
      or
      kind.isDtdRetrieval() and
      this.getArgByName("load_dtd").getALocalSource().asExpr() = any(True t) and
      this.getArgByName("no_network").getALocalSource().asExpr() = any(False t)
    }
  }

  /**
   * A call to either of:
   * - `lxml.etree.fromstring`
   * - `lxml.etree.fromstringlist`
   * - `lxml.etree.XML`
   * - `lxml.etree.parse`
   * - `lxml.etree.parseid`
   *
   * See https://lxml.de/apidoc/lxml.etree.html?highlight=parseids#lxml.etree.fromstring
   */
  private class LXMLParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    LXMLParsing() {
      this =
        API::moduleImport("lxml")
            .getMember("etree")
            .getMember(["fromstring", "fromstringlist", "XML", "parse", "parseid"])
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // fromstring / XML
          this.getArgByName("text"),
          // fromstringlist
          this.getArgByName("strings"),
          // parse / parseid
          this.getArgByName("source"),
        ]
    }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      // TODO: This should be done with type-tracking
      exists(XML::XMLParser xmlParser |
        xmlParser = this.getArgByName("parser").getALocalSource() and xmlParser.vulnerable(kind)
      )
      or
      kind.isXxe() and not exists(this.getArgByName("parser"))
    }
  }

  /**
   * A call to the `feed` method of an `lxml` parser.
   */
  private class LXMLEtreeParserFeedCall extends DataFlow::MethodCallNode, XML::XMLParsing::Range {
    LXMLEtreeParserFeedCall() {
      exists(API::Node parserInstance |
        parserInstance =
          API::moduleImport("lxml").getMember("etree").getMember("XMLParser").getReturn()
        or
        parserInstance =
          API::moduleImport("lxml").getMember("etree").getMember("get_default_parser").getReturn()
      |
        this = parserInstance.getMember("feed").getACall()
      )
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      // TODO: This should be done with type-tracking
      exists(XML::XMLParser xmlParser |
        xmlParser = this.getObject().getALocalSource() and
        xmlParser.vulnerable(kind)
      )
    }
  }
}

private module Xmltodict {
  /**
   * A call to `xmltodict.parse`.
   */
  private class XMLtoDictParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    XMLtoDictParsing() { this = API::moduleImport("xmltodict").getMember("parse").getACall() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("xml_input")]
    }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      (kind.isBillionLaughs() or kind.isQuadraticBlowup()) and
      this.getArgByName("disable_entities").getALocalSource().asExpr() = any(False f)
    }
  }
}
