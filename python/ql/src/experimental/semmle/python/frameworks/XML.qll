/**
 * Provides class and predicates to track external data that
 * may represent malicious XML objects.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module XML {
  /** Gets a reference to `xml.etree.ElementTree`. */
  private API::Node xmlEtree() {
    result = API::moduleImport("xml").getMember("etree").getMember("ElementTree")
  }

  /** Gets a call to `xml.etree.ElementTree.XMLParser`. */
  private class XMLEtreeParser extends DataFlow::CallCfgNode, XMLParser::Range {
    XMLEtreeParser() { this = xmlEtree().getMember("XMLParser").getACall() }

    override DataFlow::Node getAnInput() { none() }

    override predicate mayBeDangerous() { any() }
  }

  /**
   * Gets a call to `xml.etree.ElementTree.fromstring`, `xml.etree.ElementTree.fromstringlist`,
   * `xml.etree.ElementTree.XML` or `xml.etree.ElementTree.parse`.
   *
   * Given the following example:
   *
   * ```py
   * parser = lxml.etree.XMLParser()
   * parsed_xml = xml.etree.ElementTree.fromstring(xml_content, parser=parser).text
   * ```
   *
   * `this` would be `xml.etree.ElementTree.fromstring(xml_content, parser=parser)`
   * and `xml_content` would be the result of `getAnInput()`.
   */
  private class XMLEtreeParsing extends DataFlow::CallCfgNode, XMLParsing::Range {
    XMLEtreeParsing() {
      this = xmlEtree().getMember(["fromstring", "fromstringlist", "XML", "parse"]).getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate mayBeDangerous() {
      exists(XMLParser xmlParser |
        xmlParser.mayBeDangerous() and this.getArgByName("parser").getALocalSource() = xmlParser
      )
    }
  }

  /** Gets a reference to `xml.sax`. */
  private API::Node xmlSax() { result = API::moduleImport("xml").getMember("sax") }

  /**
   * Gets a call to `xml.sax.make_parser` and following calls.
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
   * `this` would be `xml.sax.make_parser()`, `getAnInput()` would return `StringIO(xml_content)`
   * and `mayBeDangerous()` would not hold since `xml.sax.handler.feature_external_ges` is set to
   * `False` and so is not vulnerable.
   * see https://docs.python.org/3/library/xml.sax.handler.html#xml.sax.handler.feature_external_ges
   */
  private class XMLSaxParser extends DataFlow::CallCfgNode, XMLParser::Range {
    DataFlow::CallCfgNode attrCall;

    XMLSaxParser() {
      this = xmlSax().getMember("make_parser").getACall() and
      attrCall.getFunction().(DataFlow::AttrRead).getObject().getALocalSource() = this
    }

    override DataFlow::Node getAnInput() {
      attrCall.getFunction().(DataFlow::AttrRead).getAttributeName() = "parse" and
      result = attrCall.getArg(0)
    }

    override predicate mayBeDangerous() {
      attrCall.getFunction().(DataFlow::AttrRead).getAttributeName() = "setFeature" and
      attrCall.getArg(0) = xmlSax().getMember("handler").getMember("feature_external_ges").getAUse() and
      DataFlow::localFlow(DataFlow::exprNode(any(True trueName)), attrCall.getArg(1))
    }
  }

  /** Gets a reference to `lxml.etree`. */
  private API::Node lxmlEtree() { result = API::moduleImport("lxml").getMember("etree") }

  /**
   * Gets a call to `lxml.etree.XMLParser` or `lxml.etree.get_default_parser` and `mayBeDangerous()`
   * identifies whether the argument `no_network` is set to `False` or the arguments `huge_tree`
   * or `resolve_entities` are set to True. Since `resolve_entities` default value is `True`,
   * the predicate will also succeed if the argument is not set.
   */
  private class LXMLParser extends DataFlow::CallCfgNode, XMLParser::Range {
    LXMLParser() { this = lxmlEtree().getMember(["XMLParser", "get_default_parser"]).getACall() }

    override DataFlow::Node getAnInput() { none() }

    override predicate mayBeDangerous() {
      not exists(this.getArgByName(_)) or
      DataFlow::localFlow(DataFlow::exprNode(any(False falseName)), this.getArgByName("no_network")) or
      DataFlow::localFlow(DataFlow::exprNode(any(True trueName)),
        this.getArgByName(["huge_tree", "resolve_entities"])) or
      not exists(this.getArgByName("resolve_entities"))
    }
  }

  /**
   * Gets a call to `lxml.etree.fromstring`, `xml.etree.fromstringlist`,
   * `xml.etree.XML` or `xml.etree.parse`.
   *
   * Given the following example:
   *
   * ```py
   * parser = lxml.etree.XMLParser()
   * parsed_xml = lxml.etree.fromstring(xml_content, parser=parser).text
   * ```
   *
   * `this` would be `lxml.etree.fromstring(xml_content, parser=parser)`
   * and `xml_content` would be the result of `getAnInput()`.
   */
  private class LXMLParsing extends DataFlow::CallCfgNode, XMLParsing::Range {
    LXMLParsing() {
      this = lxmlEtree().getMember(["fromstring", "fromstringlist", "XML", "parse"]).getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate mayBeDangerous() {
      exists(XMLParser xmlParser |
        xmlParser.mayBeDangerous() and this.getArgByName("parser").getALocalSource() = xmlParser
      )
      or
      not exists(this.getArgByName("parser"))
    }
  }

  /** Gets a reference to the `xmltodict` module. */
  private API::Node xmltodict() { result = API::moduleImport("xmltodict") }

  /**
   * Gets a call to `xmltodict.parse` and `mayBeDangerous()` identifies
   * whether the argument `disable_entities` is set to `False`.
   */
  private class XMLtoDictParsing extends DataFlow::CallCfgNode, XMLParsing::Range {
    XMLtoDictParsing() { this = xmltodict().getMember("parse").getACall() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate mayBeDangerous() {
      DataFlow::localFlow(DataFlow::exprNode(any(False falseName)),
        this.getArgByName("disable_entities"))
    }
  }

  /** Gets a reference to `xml.dom.minidom` or `xml.dom.pulldom`. */
  private API::Node xmlDom() {
    result = API::moduleImport("xml").getMember("dom").getMember(["minidom", "pulldom"])
  }

  /**
   * Gets a call to `xml.dom.minidom.parse` or `xml.dom.pulldom.parse`.
   *
   * Given the following example:
   *
   * ```py
   * parser = xml.sax.make_parser()
   * parser.setFeature(xml.sax.handler.feature_external_ges, True)
   * parsed_xml = xml.dom.minidom.parse(StringIO(xml_content), parser=parser).documentElement.childNod
   * ```
   *
   * `this` would be `xml.dom.minidom.parse(StringIO(xml_content), parser=parser)`
   * and `StringIO(xml_content)` would be the result of `getAnInput()`.
   */
  private class XMLDomParsing extends DataFlow::CallCfgNode, XMLParsing::Range {
    XMLDomParsing() { this = xmlDom().getMember("parse").getACall() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate mayBeDangerous() {
      exists(XMLParser xmlParser |
        xmlParser.mayBeDangerous() and this.getArgByName("parser").getALocalSource() = xmlParser
      )
    }
  }
}
