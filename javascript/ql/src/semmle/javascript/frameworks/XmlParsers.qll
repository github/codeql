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
    ExpatParserInvocation() {
      exists(string m | m = "parse" or m = "write" |
        this = moduleMethodCall("node-expat", "Parser", m)
      )
    }

    override js::Expr getSourceArgument() { result = getArgument(0) }

    override predicate resolvesEntities(EntityKind kind) {
      // only internal entities are resolved by default
      kind = InternalEntity()
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
}
