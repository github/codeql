/**
 * Provides class and predicates to track external data that
 * may represent malicious XML objects.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module XML {
  private API::Node xml() { result = API::moduleImport("xml") }

  private API::Node xmlEtree() { result = xml().getMember("etree").getMember("ElementTree") }

  private class XMLEtreeParser extends DataFlow::CallCfgNode, XMLParser::Range {
    XMLEtreeParser() { this = xmlEtree().getMember("XMLParser").getACall() }

    override DataFlow::Node getAnInput() { none() }

    override predicate mayBeDangerous() { any() }
  }

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

  private API::Node xmlSax() { result = xml().getMember("sax") }

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

  private API::Node lxml() { result = API::moduleImport("lxml") }

  private API::Node lxmlEtree() { result = lxml().getMember("etree") }

  private class LXMLParser extends DataFlow::CallCfgNode, XMLParser::Range {
    LXMLParser() { this = lxmlEtree().getMember(["XMLParser", "get_default_parser"]).getACall() }

    override DataFlow::Node getAnInput() { none() }

    override predicate mayBeDangerous() {
      not exists(this.getArgByName(_)) or
      DataFlow::localFlow(DataFlow::exprNode(any(False falseName)), this.getArgByName("no_network")) or
      DataFlow::localFlow(DataFlow::exprNode(any(True trueName)),
        this.getArgByName(["huge_tree", "resolve_entities"]))
    }
  }

  private class LXMLParsing extends DataFlow::CallCfgNode, XMLParsing::Range {
    LXMLParsing() {
      this = lxmlEtree().getMember(["fromstring", "fromstringlist", "XML"]).getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override predicate mayBeDangerous() {
      exists(XMLParser xmlParser |
        xmlParser.mayBeDangerous() and this.getArgByName("parser").getALocalSource() = xmlParser
      )
    }
  }
}
