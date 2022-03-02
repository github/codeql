/**
 * Provides class and predicates to track external data that
 * may represent malicious XML objects.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module Xml {
  /**
   * Gets a call to `xml.etree.ElementTree.XMLParser`.
   */
  private class XMLEtreeParser extends DataFlow::CallCfgNode, XML::XMLParser::Range {
    XMLEtreeParser() {
      this =
        API::moduleImport("xml")
            .getMember("etree")
            .getMember("ElementTree")
            .getMember("XMLParser")
            .getACall()
    }

    override DataFlow::Node getAnInput() { none() }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) { none() }
  }

  /**
   * Gets a call to:
   * * `xml.etree.ElementTree.fromstring`
   * * `xml.etree.ElementTree.fromstringlist`
   * * `xml.etree.ElementTree.XML`
   * * `xml.etree.ElementTree.parse`
   *
   * Given the following example:
   *
   * ```py
   * parser = lxml.etree.XMLParser()
   * xml.etree.ElementTree.fromstring(xml_content, parser=parser).text
   * ```
   *
   * * `this` would be `xml.etree.ElementTree.fromstring(xml_content, parser=parser)`.
   * * `getAnInput()`'s result would be `xml_content`.
   * * `vulnerable(kind)`'s `kind` would be `XXE`.
   */
  private class XMLEtreeParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    XMLEtreeParsing() {
      this =
        API::moduleImport("xml")
            .getMember("etree")
            .getMember("ElementTree")
            .getMember(["fromstring", "fromstringlist", "XML", "parse"])
            .getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      exists(XML::XMLParser xmlParser |
        xmlParser = this.getArgByName("parser").getALocalSource() and xmlParser.vulnerable(kind)
      )
    }
  }

  /** Gets a reference to a `parser` that has been set a `feature`. */
  private DataFlow::Node trackSaxFeature(
    DataFlow::TypeTracker t, DataFlow::CallCfgNode parser, API::Node feature
  ) {
    t.start() and
    exists(DataFlow::MethodCallNode featureCall |
      featureCall = parser.getAMethodCall("setFeature") and
      featureCall.getArg(0).getALocalSource() = feature.getAUse() and
      featureCall.getArg(1).getALocalSource() = DataFlow::exprNode(any(True t_)) and
      result = featureCall.getObject()
    )
    or
    exists(DataFlow::TypeTracker t2 |
      t = t2.smallstep(trackSaxFeature(t2, parser, feature), result)
    )
  }

  /** Gets a reference to a `parser` that has been set a `feature`. */
  DataFlow::Node trackSaxFeature(DataFlow::CallCfgNode parser, API::Node feature) {
    result = trackSaxFeature(DataFlow::TypeTracker::end(), parser, feature)
  }

  /**
   * Gets a call to `xml.sax.make_parser`.
   *
   * Given the following example:
   *
   * ```py
   * BadHandler = MainHandler()
   * parser = xml.sax.make_parser()
   * parser.setContentHandler(BadHandler)
   * parser.setFeature(xml.sax.handler.feature_external_ges, False)
   * parser.parse(StringIO(xml_content))
   * parsed_xml = BadHandler._result
   * ```
   *
   * * `this` would be `xml.sax.make_parser()`.
   * * `getAnInput()`'s result would be `StringIO(xml_content)`.
   * * `vulnerable(kind)`'s `kind` would be `Billion Laughs` and `Quadratic Blowup`.
   */
  private class XMLSaxParser extends DataFlow::CallCfgNode, XML::XMLParser::Range {
    XMLSaxParser() {
      this = API::moduleImport("xml").getMember("sax").getMember("make_parser").getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getAMethodCall("parse").getArg(0) }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      exists(DataFlow::MethodCallNode parse, API::Node handler, API::Node feature |
        handler = API::moduleImport("xml").getMember("sax").getMember("handler") and
        parse.calls(trackSaxFeature(this, feature), "parse") and
        parse.getArg(0) = this.getAnInput() // enough to avoid FPs?
      |
        (kind.isXxe() or kind.isDtdRetrieval()) and
        feature = handler.getMember("feature_external_ges")
        or
        (kind.isBillionLaughs() or kind.isQuadraticBlowup())
      )
    }

    predicate vulnerable(DataFlow::Node n, XML::XMLVulnerabilityKind kind) {
      exists(API::Node handler, API::Node feature |
        handler = API::moduleImport("xml").getMember("sax").getMember("handler") and
        DataFlow::exprNode(trackSaxFeature(this, feature).asExpr())
            .(DataFlow::LocalSourceNode)
            .flowsTo(n)
      |
        (kind.isXxe() or kind.isDtdRetrieval()) and
        feature = handler.getMember("feature_external_ges")
      )
    }
  }

  /**
   * Gets a call to:
   * * `lxml.etree.XMLParser`
   * * `lxml.etree.get_default_parser`
   *
   * Given the following example:
   *
   * ```py
   * lxml.etree.XMLParser()
   * ```
   *
   * * `this` would be `lxml.etree.XMLParser(resolve_entities=False)`.
   * * `vulnerable(kind)`'s `kind` would be `XXE`
   */
  private class LXMLParser extends DataFlow::CallCfgNode, XML::XMLParser::Range {
    LXMLParser() {
      this =
        API::moduleImport("lxml")
            .getMember("etree")
            .getMember(["XMLParser", "get_default_parser"])
            .getACall()
    }

    override DataFlow::Node getAnInput() { none() }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      kind.isXxe() and
      not (
        exists(this.getArgByName("resolve_entities")) or
        this.getArgByName("resolve_entities").getALocalSource().asExpr() = any(False f)
      )
      or
      (kind.isBillionLaughs() or kind.isQuadraticBlowup()) and
      (
        this.getArgByName("huge_tree").getALocalSource().asExpr() = any(True t) and
        not this.getArgByName("resolve_entities").getALocalSource().asExpr() = any(False f)
      )
    }
  }

  /**
   * Gets a call to:
   * * `lxml.etree.fromstring`
   * * `xml.etree.fromstringlist`
   * * `xml.etree.XML`
   * * `xml.etree.parse`
   *
   * Given the following example:
   *
   * ```py
   * parser = lxml.etree.XMLParser()
   * lxml.etree.fromstring(xml_content, parser=parser).text
   * ```
   *
   * * `this` would be `lxml.etree.fromstring(xml_content, parser=parser)`.
   * * `getAnInput()`'s result would be `xml_content`.
   * * `vulnerable(kind)`'s `kind` would be `XXE`.
   */
  private class LXMLParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    LXMLParsing() {
      this =
        API::moduleImport("lxml")
            .getMember("etree")
            .getMember(["fromstring", "fromstringlist", "XML", "parse"])
            .getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      exists(XML::XMLParser xmlParser |
        xmlParser = this.getArgByName("parser").getALocalSource() and xmlParser.vulnerable(kind)
      )
      or
      kind.isXxe() and not exists(this.getArgByName("parser"))
    }
  }

  /**
   * Gets a call to `xmltodict.parse`.
   *
   * Given the following example:
   *
   * ```py
   * xmltodict.parse(xml_content, disable_entities=False)
   * ```
   *
   * * `this` would be `xmltodict.parse(xml_content, disable_entities=False)`.
   * * `getAnInput()`'s result would be `xml_content`.
   * * `vulnerable(kind)`'s `kind` would be `Billion Laughs` and `Quadratic Blowup`.
   */
  private class XMLtoDictParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    XMLtoDictParsing() { this = API::moduleImport("xmltodict").getMember("parse").getACall() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      (kind.isBillionLaughs() or kind.isQuadraticBlowup()) and
      this.getArgByName("disable_entities").getALocalSource().asExpr() = any(False f)
    }
  }

  /**
   * Gets a call to:
   * * `xml.dom.minidom.parse`
   * * `xml.dom.pulldom.parse`
   *
   * Given the following example:
   *
   * ```py
   * xml.dom.minidom.parse(StringIO(xml_content)).documentElement.childNode
   * ```
   *
   * * `this` would be `xml.dom.minidom.parse(StringIO(xml_content), parser=parser)`.
   * * `getAnInput()`'s result would be `StringIO(xml_content)`.
   * * `vulnerable(kind)`'s `kind` would be `Billion Laughs` and `Quadratic Blowup`.
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

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      exists(XML::XMLParser xmlParser |
        xmlParser = this.getArgByName("parser").getALocalSource() and xmlParser.vulnerable(kind)
      )
      or
      (kind.isBillionLaughs() or kind.isQuadraticBlowup()) and
      not exists(this.getArgByName("parser"))
    }
  }

  /**
   * Gets a call to `xmlrpc.server.SimpleXMLRPCServer`.
   *
   * Given the following example:
   *
   * ```py
   * server = SimpleXMLRPCServer(("127.0.0.1", 8000))
   * server.register_function(foo, "foo")
   * server.serve_forever()
   * ```
   *
   * * `this` would be `SimpleXMLRPCServer(("127.0.0.1", 8000))`.
   * * `getAnInput()`'s result would be `foo`.
   * * `vulnerable(kind)`'s `kind` would be `Billion Laughs` and `Quadratic Blowup`.
   */
  private class XMLRPCServer extends DataFlow::CallCfgNode, XML::XMLParser::Range {
    XMLRPCServer() {
      this =
        API::moduleImport("xmlrpc").getMember("server").getMember("SimpleXMLRPCServer").getACall()
    }

    override DataFlow::Node getAnInput() {
      result = this.getAMethodCall("register_function").getArg(0)
    }

    override predicate vulnerable(XML::XMLVulnerabilityKind kind) {
      kind.isBillionLaughs() or kind.isQuadraticBlowup()
    }
  }
}
