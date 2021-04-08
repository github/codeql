/**
 * Provides classes for working with XML parser APIs.
 */

import javascript as js

module XML {
  /**
   * A representation of the different kinds of entities in XML.
   */
  newtype EntityKind =
    /** Internal general entity. */
    InternalEntity() or
    /** External general entity, either parsed or unparsed. */
    ExternalEntity(boolean parsed) { parsed = true or parsed = false } or
    /** Parameter entity, either internal or external. */
    ParameterEntity(boolean external) { external = true or external = false }

  /**
   * A call to an XML parsing function.
   */
  abstract class ParserInvocation extends js::InvokeExpr {
    /** Gets an argument to this call that is parsed as XML. */
    abstract js::Expr getSourceArgument();

    /** Holds if this call to the XML parser resolves entities of the given `kind`. */
    abstract predicate resolvesEntities(EntityKind kind);

    /** Gets a reference to a value resulting from parsing the XML. */
    js::DataFlow::Node getAResult() { none() }
  }

  /**
   * An invocation of `libxmljs.parseXml` or `libxmljs.parseXmlString`.
   */
  class LibXmlJsParserInvocation extends ParserInvocation {
    LibXmlJsParserInvocation() {
      exists(string m |
        this = js::DataFlow::moduleMember("libxmljs", m).getACall().asExpr() and
        m.matches("parseXml%")
      )
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // internal entities are always resolved
      kind = InternalEntity()
      or
      // other entities are only resolved if the configuration option `noent` is set to `true`
      exists(js::Expr noent |
        hasOptionArgument(1, "noent", noent) and
        noent.mayHaveBooleanValue(true)
      )
    }
  }

  /**
   * Gets a call to method `methodName` on an instance of class `className` from module `modName`.
   */
  private js::MethodCallExpr moduleMethodCall(string modName, string className, string methodName) {
    exists(js::DataFlow::ModuleImportNode mod |
      mod.getPath() = modName and
      result = mod.getAConstructorInvocation(className).getAMethodCall(methodName).asExpr()
    )
  }

  /**
   * An invocation of `libxmljs.SaxParser.parseString`.
   */
  class LibXmlJsSaxParserInvocation extends ParserInvocation {
    LibXmlJsSaxParserInvocation() {
      this = moduleMethodCall("libxmljs", "SaxParser", "parseString")
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // entities are resolved by default
      any()
    }
  }

  /**
   * An invocation of `libxmljs.SaxPushParser.push`.
   */
  class LibXmlJsSaxPushParserInvocation extends ParserInvocation {
    LibXmlJsSaxPushParserInvocation() {
      this = moduleMethodCall("libxmljs", "SaxPushParser", "push")
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // entities are resolved by default
      any()
    }
  }

  /**
   * An invocation of `expat.Parser.parse` or `expat.Parser.write`.
   */
  class ExpatParserInvocation extends ParserInvocation {
    js::DataFlow::NewNode parser;

    ExpatParserInvocation() {
      parser = js::DataFlow::moduleMember("node-expat", "Parser").getAnInstantiation() and
      this = parser.getAMemberCall(["parse", "write"]).asExpr()
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // only internal entities are resolved by default
      kind = InternalEntity()
    }

    override js::DataFlow::Node getAResult() {
      result = parser.getAMemberCall("on").getABoundCallbackParameter(1, _)
    }
  }

  /**
   * An invocation of `DOMParser.parseFromString`.
   */
  private class DOMParserXmlParserInvocation extends XML::ParserInvocation {
    DOMParserXmlParserInvocation() {
      exists(js::DataFlow::GlobalVarRefNode domparser |
        domparser.getName() = "DOMParser" and
        this = domparser.getAnInstantiation().getAMethodCall("parseFromString").asExpr() and
        // type contains the string `xml`, that is, it's not `text/html`
        getArgument(1).mayHaveStringValue(any(string tp | tp.matches("%xml%")))
      )
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) { kind = InternalEntity() }
  }

  /**
   * An invocation of `loadXML` on an IE legacy XML DOM or MSXML object.
   */
  private class IELegacyXmlParserInvocation extends XML::ParserInvocation {
    IELegacyXmlParserInvocation() {
      exists(js::DataFlow::NewNode activeXObject, string activeXType |
        activeXObject = js::DataFlow::globalVarRef("ActiveXObject").getAnInstantiation() and
        activeXObject.getArgument(0).asExpr().mayHaveStringValue(activeXType) and
        activeXType.regexpMatch("Microsoft\\.XMLDOM|Msxml.*\\.DOMDocument.*") and
        this = activeXObject.getAMethodCall("loadXML").asExpr()
      )
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) { any() }
  }

  /**
   * An invocation of `goog.dom.xml.loadXml`.
   */
  private class GoogDomXmlParserInvocation extends XML::ParserInvocation {
    GoogDomXmlParserInvocation() {
      this.getCallee().(js::PropAccess).getQualifiedName() = "goog.dom.xml.loadXml"
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) { kind = InternalEntity() }
  }

  /**
   * An invocation of `xml2js`.
   */
  private class Xml2JSInvocation extends XML::ParserInvocation {
    js::DataFlow::CallNode call;

    Xml2JSInvocation() {
      exists(js::API::Node imp | imp = js::API::moduleImport("xml2js") |
        call = [imp, imp.getMember("Parser").getInstance()].getMember("parseString").getACall() and
        this = call.asExpr()
      )
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // sax-js (the parser used) does not expand entities.
      none()
    }

    override js::DataFlow::Node getAResult() {
      result = call.getABoundCallbackParameter(call.getNumArgument() - 1, 1)
    }
  }

  /**
   * An invocation of `sax`.
   */
  private class SaxInvocation extends XML::ParserInvocation {
    js::DataFlow::InvokeNode parser;

    SaxInvocation() {
      exists(js::API::Node imp | imp = js::API::moduleImport("sax") |
        parser = imp.getMember("parser").getACall()
        or
        parser = imp.getMember("SAXParser").getAnInstantiation()
      ) and
      this = parser.getAMemberCall("write").asExpr()
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // sax-js does not expand entities.
      none()
    }

    override js::DataFlow::Node getAResult() {
      result =
        parser
            .getAPropertyWrite(any(string s | s.matches("on%")))
            .getRhs()
            .getAFunctionValue()
            .getAParameter()
    }
  }

  /**
   * An invocation of `xml-js`.
   */
  private class XmlJSInvocation extends XML::ParserInvocation {
    XmlJSInvocation() {
      this =
        js::DataFlow::moduleMember("xml-js", ["xml2json", "xml2js", "json2xml", "js2xml"])
            .getACall()
            .asExpr()
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // xml-js does not expand custom entities.
      none()
    }

    override js::DataFlow::Node getAResult() { result.asExpr() = this }
  }

  /**
   * An invocation of `htmlparser2`.
   */
  private class HtmlParser2Invocation extends XML::ParserInvocation {
    js::DataFlow::NewNode parser;

    HtmlParser2Invocation() {
      parser = js::DataFlow::moduleMember("htmlparser2", "Parser").getAnInstantiation() and
      this = parser.getAMemberCall("write").asExpr()
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(XML::EntityKind kind) {
      // htmlparser2 does not expand entities.
      none()
    }

    override js::DataFlow::Node getAResult() {
      result =
        parser
            .getArgument(0)
            .getALocalSource()
            .getAPropertySource()
            .getAFunctionValue()
            .getAParameter()
    }
  }

  private class XMLParserTaintStep extends js::TaintTracking::SharedTaintStep {
    override predicate deserializeStep(js::DataFlow::Node pred, js::DataFlow::Node succ) {
      exists(XML::ParserInvocation parser |
        pred.asExpr() = parser.getSourceArgument() and
        succ = parser.getAResult()
      )
    }
  }
}
