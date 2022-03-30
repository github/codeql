/**
 * Provides classes for working with XML parser APIs.
 */

private import javascript as JS
private import JS::DataFlow as DataFlow
private import JS::API as API

module XML {
  /**
   * A representation of the different kinds of entities in XML.
   */
  newtype EntityKind =
    /** Internal general entity. */
    InternalEntity() or
    /** External general entity, either parsed or unparsed. */
    ExternalEntity(boolean parsed) { parsed = [true, false] } or
    /** Parameter entity, either internal or external. */
    ParameterEntity(boolean external) { external = [true, false] }

  /**
   * A call to an XML parsing function.
   */
  abstract class ParserInvocation extends JS::InvokeExpr {
    /** Gets an argument to this call that is parsed as XML. */
    abstract JS::Expr getSourceArgument();

    /** Holds if this call to the XML parser resolves entities of the given `kind`. */
    abstract predicate resolvesEntities(EntityKind kind);

    /** Gets a reference to a value resulting from parsing the XML. */
    DataFlow::Node getAResult() { none() }
  }

  /**
   * An invocation of `libxmljs.parseXml` or `libxmljs.parseXmlString`.
   */
  class LibXmlJsParserInvocation extends ParserInvocation {
    API::CallNode call;

    LibXmlJsParserInvocation() {
      exists(string m |
        call = API::moduleImport("libxmljs").getMember(m).getACall() and
        this = call.asExpr() and
        m.matches("parseXml%")
      )
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // internal entities are always resolved
      kind = InternalEntity()
      or
      // other entities are only resolved if the configuration option `noent` is set to `true`
      exists(JS::Expr noent |
        hasOptionArgument(1, "noent", noent) and
        noent.mayHaveBooleanValue(true)
      )
    }

    /**
     * Gets a document from the `libxmljs` library.
     * The API is based on https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/libxmljs/index.d.ts
     */
    private API::Node doc() {
      result = call.getReturn()
      or
      result = doc().getMember("encoding").getReturn()
      or
      result = element().getMember("doc").getReturn()
      or
      result = element().getMember("parent").getReturn()
    }

    /**
     * Gets an `Element` from the `libxmljs` library.
     */
    private API::Node element() {
      result = doc().getMember(["child", "get", "node", "root"]).getReturn()
      or
      result = [doc(), element()].getMember(["childNodes", "find"]).getReturn().getAMember()
      or
      result =
        element()
            .getMember([
                "parent", "prevSibling", "nextSibling", "remove", "clone", "node", "child",
                "prevElement", "nextElement"
              ])
            .getReturn()
    }

    /**
     * Gets an `Attr` from the `libxmljs` library.
     */
    private API::Node attr() {
      result = element().getMember("attr").getReturn()
      or
      result = element().getMember("attrs").getReturn().getAMember()
    }

    override DataFlow::Node getAResult() {
      result = [doc(), element(), attr()].getAnImmediateUse()
      or
      result = element().getMember(["name", "text"]).getACall()
      or
      result = attr().getMember(["name", "value"]).getACall()
      or
      result = element().getMember("namespace").getReturn().getMember(["href", "prefix"]).getACall()
    }
  }

  /**
   * An invocation of `libxmljs.SaxParser.parseString`.
   */
  class LibXmlJsSaxParserInvocation extends ParserInvocation {
    API::Node parser;

    LibXmlJsSaxParserInvocation() {
      parser = API::moduleImport("libxmljs").getMember("SaxParser").getInstance() and
      this = parser.getMember("parseString").getACall().asExpr()
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // entities are resolved by default
      any()
    }

    override DataFlow::Node getAResult() {
      result = parser.getMember("on").getACall().getABoundCallbackParameter(1, _)
    }
  }

  /**
   * An invocation of `libxmljs.SaxPushParser.push`.
   */
  class LibXmlJsSaxPushParserInvocation extends ParserInvocation {
    API::Node parser;

    LibXmlJsSaxPushParserInvocation() {
      parser = API::moduleImport("libxmljs").getMember("SaxPushParser").getInstance() and
      this = parser.getMember("push").getACall().asExpr()
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // entities are resolved by default
      any()
    }

    override DataFlow::Node getAResult() {
      result = parser.getMember("on").getACall().getABoundCallbackParameter(1, _)
    }
  }

  /**
   * An invocation of `expat.Parser.parse` or `expat.Parser.write`.
   */
  class ExpatParserInvocation extends ParserInvocation {
    API::Node parser;

    ExpatParserInvocation() {
      parser = API::moduleImport("node-expat").getMember("Parser").getInstance() and
      this = parser.getMember(["parse", "write"]).getACall().asExpr()
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // only internal entities are resolved by default
      kind = InternalEntity()
    }

    override DataFlow::Node getAResult() {
      result = parser.getMember("on").getACall().getABoundCallbackParameter(1, _)
    }
  }

  /**
   * An invocation of `DOMParser.parseFromString`.
   */
  private class DomParserXmlParserInvocation extends XML::ParserInvocation {
    DomParserXmlParserInvocation() {
      this =
        DataFlow::globalVarRef("DOMParser")
            .getAnInstantiation()
            .getAMethodCall("parseFromString")
            .asExpr() and
      // type contains the string `xml`, that is, it's not `text/html`
      getArgument(1).mayHaveStringValue(any(string tp | tp.matches("%xml%")))
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) { kind = InternalEntity() }

    // The result is an XMLDocument (https://developer.mozilla.org/en-US/docs/Web/API/XMLDocument).
    // The API of the XMLDocument is not modelled.
    override DataFlow::Node getAResult() { result.asExpr() = this }
  }

  /**
   * An invocation of `loadXML` on an IE legacy XML DOM or MSXML object.
   */
  private class IELegacyXmlParserInvocation extends XML::ParserInvocation {
    IELegacyXmlParserInvocation() {
      exists(DataFlow::NewNode activeXObject, string activeXType |
        activeXObject = DataFlow::globalVarRef("ActiveXObject").getAnInstantiation() and
        activeXObject.getArgument(0).asExpr().mayHaveStringValue(activeXType) and
        activeXType.regexpMatch("Microsoft\\.XMLDOM|Msxml.*\\.DOMDocument.*") and
        this = activeXObject.getAMethodCall("loadXML").asExpr()
      )
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) { any() }
  }

  /**
   * An invocation of `goog.dom.xml.loadXml`.
   */
  private class GoogDomXmlParserInvocation extends XML::ParserInvocation {
    GoogDomXmlParserInvocation() {
      this.getCallee().(JS::PropAccess).getQualifiedName() = "goog.dom.xml.loadXml"
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) { kind = InternalEntity() }
  }

  /**
   * An invocation of `xml2js`.
   */
  private class Xml2JSInvocation extends XML::ParserInvocation {
    API::CallNode call;

    Xml2JSInvocation() {
      exists(API::Node imp | imp = API::moduleImport("xml2js") |
        call = [imp, imp.getMember("Parser").getInstance()].getMember("parseString").getACall() and
        this = call.asExpr()
      )
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // sax-js (the parser used) does not expand entities.
      none()
    }

    override DataFlow::Node getAResult() {
      result = call.getABoundCallbackParameter(call.getNumArgument() - 1, 1)
    }
  }

  /**
   * An invocation of `sax`.
   */
  private class SaxInvocation extends XML::ParserInvocation {
    API::InvokeNode parser;

    SaxInvocation() {
      exists(API::Node imp | imp = API::moduleImport("sax") |
        parser = imp.getMember("parser").getACall()
        or
        parser = imp.getMember("SAXParser").getAnInstantiation()
      ) and
      this = parser.getAMemberCall("write").asExpr()
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // sax-js does not expand entities.
      none()
    }

    override DataFlow::Node getAResult() {
      result =
        parser
            .getReturn()
            .getMember(any(string s | s.matches("on%")))
            .getAParameter()
            .getAnImmediateUse()
    }
  }

  /**
   * An invocation of `xml-js`.
   */
  private class XmlJSInvocation extends XML::ParserInvocation {
    XmlJSInvocation() {
      this =
        API::moduleImport("xml-js")
            .getMember(["xml2json", "xml2js", "json2xml", "js2xml"])
            .getACall()
            .asExpr()
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // xml-js does not expand custom entities.
      none()
    }

    override DataFlow::Node getAResult() { result.asExpr() = this }
  }

  /**
   * An invocation of `htmlparser2`.
   */
  private class HtmlParser2Invocation extends XML::ParserInvocation {
    API::NewNode parser;

    HtmlParser2Invocation() {
      parser = API::moduleImport("htmlparser2").getMember("Parser").getAnInstantiation() and
      this = parser.getReturn().getMember("write").getACall().asExpr()
    }

    override JS::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // htmlparser2 does not expand entities.
      none()
    }

    override DataFlow::Node getAResult() {
      result =
        parser
            .getArgument(0)
            .getALocalSource()
            .getAPropertySource()
            .getAFunctionValue()
            .getAParameter()
    }
  }

  private class XmlParserTaintStep extends JS::TaintTracking::SharedTaintStep {
    override predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(XML::ParserInvocation parser |
        pred.asExpr() = parser.getSourceArgument() and
        succ = parser.getAResult()
      )
    }
  }
}
