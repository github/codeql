/** Provides classes and predicates for modeling XML parsers in Java. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.DataFlow4
import semmle.code.java.dataflow.DataFlow5
private import semmle.code.java.dataflow.SSA

/*
 * Various XML parsers in Java.
 */

/**
 * An abstract type representing a call to parse XML files.
 */
abstract class XmlParserCall extends MethodAccess {
  /**
   * Gets the argument representing the XML content to be parsed.
   */
  abstract Expr getSink();

  /**
   * Holds if the call is safe.
   */
  abstract predicate isSafe();
}

/**
 * An access to a method use for configuring the parser.
 */
abstract class ParserConfig extends MethodAccess {
  /**
   * Holds if the method disables a property.
   */
  predicate disables(Expr e) {
    this.getArgument(0) = e and
    (
      this.getArgument(1).(BooleanLiteral).getBooleanValue() = false or
      this.getArgument(1).(FieldAccess).getField().hasQualifiedName("java.lang", "Boolean", "FALSE")
    )
  }

  /**
   * Holds if the method enables a property.
   */
  predicate enables(Expr e) {
    this.getArgument(0) = e and
    (
      this.getArgument(1).(BooleanLiteral).getBooleanValue() = true or
      this.getArgument(1).(FieldAccess).getField().hasQualifiedName("java.lang", "Boolean", "TRUE")
    )
  }
}

/*
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#jaxp-documentbuilderfactory-saxparserfactory-and-dom4j
 */

/** The class `javax.xml.parsers.DocumentBuilderFactory`. */
class DocumentBuilderFactory extends RefType {
  DocumentBuilderFactory() { this.hasQualifiedName("javax.xml.parsers", "DocumentBuilderFactory") }
}

/** The class `javax.xml.parsers.DocumentBuilder`. */
class DocumentBuilder extends RefType {
  DocumentBuilder() { this.hasQualifiedName("javax.xml.parsers", "DocumentBuilder") }
}

/** A call to `DocumentBuilder.parse`. */
class DocumentBuilderParse extends XmlParserCall {
  DocumentBuilderParse() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof DocumentBuilder and
      m.hasName("parse")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeDocumentBuilderToDocumentBuilderParseFlowConfig conf |
      conf.hasFlowToExpr(this.getQualifier())
    )
  }
}

private class SafeDocumentBuilderToDocumentBuilderParseFlowConfig extends DataFlow2::Configuration {
  SafeDocumentBuilderToDocumentBuilderParseFlowConfig() {
    this = "XmlParsers::SafeDocumentBuilderToDocumentBuilderParseFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeDocumentBuilder }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(DocumentBuilderParse dbp).getQualifier()
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(RefType t, ReturnStmt ret, Method m |
      node2.asExpr().(ClassInstanceExpr).getConstructedType().getSourceDeclaration() = t and
      t.getASourceSupertype+().hasQualifiedName("java.lang", "ThreadLocal") and
      ret.getResult() = node1.asExpr() and
      ret.getEnclosingCallable() = m and
      m.hasName("initialValue") and
      m.getDeclaringType() = t
    )
    or
    exists(MethodAccess ma, Method m |
      ma = node2.asExpr() and
      ma.getQualifier() = node1.asExpr() and
      ma.getMethod() = m and
      m.hasName("get") and
      m.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.lang", "ThreadLocal")
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/**
 * A `ParserConfig` specific to `DocumentBuilderFactory`.
 */
class DocumentBuilderFactoryConfig extends ParserConfig {
  DocumentBuilderFactoryConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof DocumentBuilderFactory and
      m.hasName("setFeature")
    )
  }
}

private predicate constantStringExpr(Expr e, string val) {
  e.(CompileTimeConstantExpr).getStringValue() = val
  or
  exists(SsaExplicitUpdate v, Expr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(VariableAssign).getSource() and
    constantStringExpr(src, val)
  )
}

/** An expression that always has the same string value. */
private class ConstantStringExpr extends Expr {
  string value;

  ConstantStringExpr() { constantStringExpr(this, value) }

  /** Get the string value of this expression. */
  string getStringValue() { result = value }
}

/**
 * A general configuration that is safe when enabled.
 */
Expr singleSafeConfig() {
  result.(ConstantStringExpr).getStringValue() =
    "http://apache.org/xml/features/disallow-doctype-decl"
}

/**
 * A safely configured `DocumentBuilderFactory` that is safe for creating `DocumentBuilder`.
 */
class SafeDocumentBuilderFactory extends VarAccess {
  SafeDocumentBuilderFactory() {
    exists(Variable v | v = this.getVariable() |
      exists(DocumentBuilderFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.enables(singleSafeConfig())
      )
      or
      //These two need to be set together to work
      exists(DocumentBuilderFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(DocumentBuilderFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      )
    )
  }
}

private class DocumentBuilderConstruction extends MethodAccess {
  DocumentBuilderConstruction() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof DocumentBuilderFactory and
      m.hasName("newDocumentBuilder")
    )
  }
}

private class SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlowConfig extends DataFlow3::Configuration {
  SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlowConfig() {
    this = "XmlParsers::SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof SafeDocumentBuilderFactory
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(DocumentBuilderConstruction dbc).getQualifier()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/**
 * A `DocumentBuilder` created from a safely configured `DocumentBuilderFactory`.
 */
class SafeDocumentBuilder extends DocumentBuilderConstruction {
  SafeDocumentBuilder() {
    exists(SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlowConfig conf |
      conf.hasFlowToExpr(this.getQualifier())
    )
  }
}

/*
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#xmlinputfactory-a-stax-parser
 */

/** The class `javax.xml.stream.XMLInputFactory`. */
class XmlInputFactory extends RefType {
  XmlInputFactory() { this.hasQualifiedName("javax.xml.stream", "XMLInputFactory") }
}

/** A call to `XMLInputFactory.createXMLStreamReader`. */
class XmlInputFactoryStreamReader extends XmlParserCall {
  XmlInputFactoryStreamReader() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XmlInputFactory and
      m.hasName("createXMLStreamReader")
    )
  }

  override Expr getSink() {
    if this.getMethod().getParameterType(0) instanceof TypeString
    then result = this.getArgument(1)
    else result = this.getArgument(0)
  }

  override predicate isSafe() {
    exists(SafeXmlInputFactoryToXmlInputFactoryReaderFlowConfig conf |
      conf.hasFlowToExpr(this.getQualifier())
    )
  }
}

private class SafeXmlInputFactoryToXmlInputFactoryReaderFlowConfig extends DataFlow2::Configuration {
  SafeXmlInputFactoryToXmlInputFactoryReaderFlowConfig() {
    this = "XmlParsers::SafeXmlInputFactoryToXmlInputFactoryReaderFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeXmlInputFactory }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(XmlInputFactoryStreamReader xifsr).getQualifier() or
    sink.asExpr() = any(XmlInputFactoryEventReader xifer).getQualifier()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A call to `XMLInputFactory.createEventReader`. */
class XmlInputFactoryEventReader extends XmlParserCall {
  XmlInputFactoryEventReader() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XmlInputFactory and
      m.hasName("createXMLEventReader")
    )
  }

  override Expr getSink() {
    if this.getMethod().getParameterType(0) instanceof TypeString
    then result = this.getArgument(1)
    else result = this.getArgument(0)
  }

  override predicate isSafe() {
    exists(SafeXmlInputFactoryToXmlInputFactoryReaderFlowConfig conf |
      conf.hasFlowToExpr(this.getQualifier())
    )
  }
}

/**
 * A `ParserConfig` specific to `XMLInputFactory`.
 */
class XmlInputFactoryConfig extends ParserConfig {
  XmlInputFactoryConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof XmlInputFactory and
      m.hasName("setProperty")
    )
  }
}

/**
 * An `XmlInputFactory` specific expression that indicates whether parsing external entities is supported.
 */
Expr configOptionIsSupportingExternalEntities() {
  result.(ConstantStringExpr).getStringValue() = "javax.xml.stream.isSupportingExternalEntities"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("IS_SUPPORTING_EXTERNAL_ENTITIES") and
    f.getDeclaringType() instanceof XmlInputFactory
  )
}

/**
 * An `XmlInputFactory` specific expression that indicates whether DTD is supported.
 */
Expr configOptionSupportDTD() {
  result.(ConstantStringExpr).getStringValue() = "javax.xml.stream.supportDTD"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("SUPPORT_DTD") and
    f.getDeclaringType() instanceof XmlInputFactory
  )
}

/**
 * A safely configured `XmlInputFactory`.
 */
class SafeXmlInputFactory extends VarAccess {
  SafeXmlInputFactory() {
    exists(Variable v |
      v = this.getVariable() and
      exists(XmlInputFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configOptionIsSupportingExternalEntities())
      ) and
      exists(XmlInputFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configOptionSupportDTD())
      )
    )
  }
}

/*
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#saxbuilder
 */

/**
 * The class `org.jdom.input.SAXBuilder.`
 */
class SaxBuilder extends RefType {
  SaxBuilder() {
    this.hasQualifiedName("org.jdom.input", "SAXBuilder") or
    this.hasQualifiedName("org.jdom2.input", "SAXBuilder")
  }
}

/** DEPRECATED: Alias for SaxBuilder */
deprecated class SAXBuilder = SaxBuilder;

/**
 * A call to `SAXBuilder.build.`
 */
class SaxBuilderParse extends XmlParserCall {
  SaxBuilderParse() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxBuilder and
      m.hasName("build")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeSaxBuilderToSaxBuilderParseFlowConfig conf | conf.hasFlowToExpr(this.getQualifier()))
  }
}

/** DEPRECATED: Alias for SaxBuilderParse */
deprecated class SAXBuilderParse = SaxBuilderParse;

private class SafeSaxBuilderToSaxBuilderParseFlowConfig extends DataFlow2::Configuration {
  SafeSaxBuilderToSaxBuilderParseFlowConfig() {
    this = "XmlParsers::SafeSAXBuilderToSAXBuilderParseFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxBuilder }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(SaxBuilderParse sax).getQualifier()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/**
 * A `ParserConfig` specific to `SAXBuilder`.
 */
class SaxBuilderConfig extends ParserConfig {
  SaxBuilderConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxBuilder and
      m.hasName("setFeature")
    )
  }
}

/** DEPRECATED: Alias for SaxBuilderConfig */
deprecated class SAXBuilderConfig = SaxBuilderConfig;

/** A safely configured `SaxBuilder`. */
class SafeSaxBuilder extends VarAccess {
  SafeSaxBuilder() {
    exists(Variable v |
      v = this.getVariable() and
      exists(SaxBuilderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .enables(any(ConstantStringExpr s |
                s.getStringValue() = "http://apache.org/xml/features/disallow-doctype-decl"
              ))
      )
    )
  }
}

/** DEPRECATED: Alias for SafeSaxBuilder */
deprecated class SafeSAXBuilder = SafeSaxBuilder;

/*
 * The case in
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#jaxb-unmarshaller
 * will be split into two, one covers a SAXParser as a sink, the other the SAXSource as a sink.
 */

/**
 * The class `javax.xml.parsers.SAXParser`.
 */
class SaxParser extends RefType {
  SaxParser() { this.hasQualifiedName("javax.xml.parsers", "SAXParser") }
}

/** DEPRECATED: Alias for SaxParser */
deprecated class SAXParser = SaxParser;

/** The class `javax.xml.parsers.SAXParserFactory`. */
class SaxParserFactory extends RefType {
  SaxParserFactory() { this.hasQualifiedName("javax.xml.parsers", "SAXParserFactory") }
}

/** DEPRECATED: Alias for SaxParserFactory */
deprecated class SAXParserFactory = SaxParserFactory;

/** A call to `SAXParser.parse`. */
class SaxParserParse extends XmlParserCall {
  SaxParserParse() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxParser and
      m.hasName("parse")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeSaxParserFlowConfig sp | sp.hasFlowToExpr(this.getQualifier()))
  }
}

/** DEPRECATED: Alias for SaxParserParse */
deprecated class SAXParserParse = SaxParserParse;

/** A `ParserConfig` that is specific to `SaxParserFactory`. */
class SaxParserFactoryConfig extends ParserConfig {
  SaxParserFactoryConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxParserFactory and
      m.hasName("setFeature")
    )
  }
}

/** DEPRECATED: Alias for SaxParserFactoryConfig */
deprecated class SAXParserFactoryConfig = SaxParserFactoryConfig;

/**
 * A safely configured `SAXParserFactory`.
 */
class SafeSaxParserFactory extends VarAccess {
  SafeSaxParserFactory() {
    exists(Variable v | v = this.getVariable() |
      exists(SaxParserFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.enables(singleSafeConfig())
      )
      or
      exists(SaxParserFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(SaxParserFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      ) and
      exists(SaxParserFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() =
                  "http://apache.org/xml/features/nonvalidating/load-external-dtd"
              ))
      )
    )
  }
}

/** DEPRECATED: Alias for SafeSaxParserFactory */
deprecated class SafeSAXParserFactory = SafeSaxParserFactory;

private class SafeSaxParserFactoryToNewSaxParserFlowConfig extends DataFlow5::Configuration {
  SafeSaxParserFactoryToNewSaxParserFlowConfig() {
    this = "XmlParsers::SafeSAXParserFactoryToNewSAXParserFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxParserFactory }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() = m and
      m.getDeclaringType() instanceof SaxParserFactory and
      m.hasName("newSAXParser")
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

private class SafeSaxParserFlowConfig extends DataFlow4::Configuration {
  SafeSaxParserFlowConfig() { this = "XmlParsers::SafeSAXParserFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxParser }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof SaxParser
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A `SaxParser` created from a safely configured `SaxParserFactory`. */
class SafeSaxParser extends MethodAccess {
  SafeSaxParser() {
    exists(SafeSaxParserFactoryToNewSaxParserFlowConfig sdf |
      this.getMethod().getDeclaringType() instanceof SaxParserFactory and
      this.getMethod().hasName("newSAXParser") and
      sdf.hasFlowToExpr(this.getQualifier())
    )
  }
}

/** DEPRECATED: Alias for SafeSaxParser */
deprecated class SafeSAXParser = SafeSaxParser;

/* SAXReader: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#saxreader */
/**
 * The class `org.dom4j.io.SAXReader`.
 */
class SaxReader extends RefType {
  SaxReader() { this.hasQualifiedName("org.dom4j.io", "SAXReader") }
}

/** DEPRECATED: Alias for SaxReader */
deprecated class SAXReader = SaxReader;

/** A call to `SAXReader.read`. */
class SaxReaderRead extends XmlParserCall {
  SaxReaderRead() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxReader and
      m.hasName("read")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeSaxReaderFlowConfig sr | sr.hasFlowToExpr(this.getQualifier()))
  }
}

/** DEPRECATED: Alias for SaxReaderRead */
deprecated class SAXReaderRead = SaxReaderRead;

/** A `ParserConfig` specific to `SaxReader`. */
class SaxReaderConfig extends ParserConfig {
  SaxReaderConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxReader and
      m.hasName("setFeature")
    )
  }
}

/** DEPRECATED: Alias for SaxReaderConfig */
deprecated class SAXReaderConfig = SaxReaderConfig;

private class SafeSaxReaderFlowConfig extends DataFlow4::Configuration {
  SafeSaxReaderFlowConfig() { this = "XmlParsers::SafeSAXReaderFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxReader }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof SaxReader
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A safely configured `SaxReader`. */
class SafeSaxReader extends VarAccess {
  SafeSaxReader() {
    exists(Variable v | v = this.getVariable() |
      exists(SaxReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(SaxReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      ) and
      exists(SaxReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .enables(any(ConstantStringExpr s |
                s.getStringValue() = "http://apache.org/xml/features/disallow-doctype-decl"
              ))
      )
    )
  }
}

/** DEPRECATED: Alias for SafeSaxReader */
deprecated class SafeSAXReader = SafeSaxReader;

/* https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#xmlreader */
/** The class `org.xml.sax.XMLReader`. */
class XmlReader extends RefType {
  XmlReader() { this.hasQualifiedName("org.xml.sax", "XMLReader") }
}

/** DEPRECATED: Alias for XmlReader */
deprecated class XMLReader = XmlReader;

/** A call to `XMLReader.read`. */
class XmlReaderParse extends XmlParserCall {
  XmlReaderParse() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof XmlReader and
      m.hasName("parse")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(ExplicitlySafeXmlReader sr | sr.flowsTo(this.getQualifier())) or
    exists(CreatedSafeXmlReader cr | cr.flowsTo(this.getQualifier()))
  }
}

/** DEPRECATED: Alias for XmlReaderParse */
deprecated class XMLReaderParse = XmlReaderParse;

/** A `ParserConfig` specific to the `XmlReader`. */
class XmlReaderConfig extends ParserConfig {
  XmlReaderConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof XmlReader and
      m.hasName("setFeature")
    )
  }
}

/** DEPRECATED: Alias for XmlReaderConfig */
deprecated class XMLReaderConfig = XmlReaderConfig;

private class ExplicitlySafeXmlReaderFlowConfig extends DataFlow3::Configuration {
  ExplicitlySafeXmlReaderFlowConfig() { this = "XmlParsers::ExplicitlySafeXMLReaderFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof ExplicitlySafeXmlReader
  }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SafeXmlReaderFlowSink }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** An argument to a safe XML reader. */
class SafeXmlReaderFlowSink extends Expr {
  SafeXmlReaderFlowSink() {
    this = any(XmlReaderParse p).getQualifier() or
    this = any(ConstructedSaxSource s).getArgument(0) or
    this = any(SaxSourceSetReader s).getArgument(0)
  }
}

/** DEPRECATED: Alias for SafeXmlReaderFlowSink */
deprecated class SafeXMLReaderFlowSink = SafeXmlReaderFlowSink;

/** An `XmlReader` that is explicitly configured to be safe. */
class ExplicitlySafeXmlReader extends VarAccess {
  ExplicitlySafeXmlReader() {
    exists(Variable v | v = this.getVariable() |
      exists(XmlReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(XmlReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      ) and
      exists(XmlReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() =
                  "http://apache.org/xml/features/nonvalidating/load-external-dtd"
              ))
      )
      or
      exists(XmlReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .enables(any(ConstantStringExpr s |
                s.getStringValue() = "http://apache.org/xml/features/disallow-doctype-decl"
              ))
      )
    )
  }

  /** Holds if `SafeXmlReaderFlowSink` detects flow from this to `sink` */
  predicate flowsTo(SafeXmlReaderFlowSink sink) {
    any(ExplicitlySafeXmlReaderFlowConfig conf)
        .hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
  }
}

/** DEPRECATED: Alias for ExplicitlySafeXmlReader */
deprecated class ExplicitlySafeXMLReader = ExplicitlySafeXmlReader;

private class CreatedSafeXmlReaderFlowConfig extends DataFlow3::Configuration {
  CreatedSafeXmlReaderFlowConfig() { this = "XmlParsers::CreatedSafeXMLReaderFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CreatedSafeXmlReader }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SafeXmlReaderFlowSink }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** An `XmlReader` that is obtained from a safe source. */
class CreatedSafeXmlReader extends Call {
  CreatedSafeXmlReader() {
    //Obtained from SAXParser
    exists(SafeSaxParserFlowConfig safeParser |
      this.(MethodAccess).getMethod().getDeclaringType() instanceof SaxParser and
      this.(MethodAccess).getMethod().hasName("getXMLReader") and
      safeParser.hasFlowToExpr(this.getQualifier())
    )
    or
    //Obtained from SAXReader
    exists(SafeSaxReaderFlowConfig safeReader |
      this.(MethodAccess).getMethod().getDeclaringType() instanceof SaxReader and
      this.(MethodAccess).getMethod().hasName("getXMLReader") and
      safeReader.hasFlowToExpr(this.getQualifier())
    )
    or
    exists(RefType secureReader, string package |
      this.(ClassInstanceExpr).getConstructedType() = secureReader and
      secureReader.hasQualifiedName(package, "SecureJDKXercesXMLReader") and
      package.matches("com.google.%common.xml.parsing")
    )
  }

  /** Holds if `CreatedSafeXmlReaderFlowConfig` detects flow from this to `sink` */
  predicate flowsTo(SafeXmlReaderFlowSink sink) {
    any(CreatedSafeXmlReaderFlowConfig conf)
        .hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
  }
}

/** DEPRECATED: Alias for CreatedSafeXmlReader */
deprecated class CreatedSafeXMLReader = CreatedSafeXmlReader;

/*
 * SAXSource in
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#jaxb-unmarshaller
 */

/** The class `javax.xml.transform.sax.SAXSource` */
class SaxSource extends RefType {
  SaxSource() { this.hasQualifiedName("javax.xml.transform.sax", "SAXSource") }
}

/** DEPRECATED: Alias for SaxSource */
deprecated class SAXSource = SaxSource;

/** A call to the constructor of `SAXSource` with `XmlReader` and `InputSource`. */
class ConstructedSaxSource extends ClassInstanceExpr {
  ConstructedSaxSource() {
    this.getConstructedType() instanceof SaxSource and
    this.getNumArgument() = 2 and
    this.getArgument(0).getType() instanceof XmlReader
  }

  /**
   * Gets the argument representing the XML content to be parsed.
   */
  Expr getSink() { result = this.getArgument(1) }

  /** Holds if the resulting `SaxSource` is safe. */
  predicate isSafe() {
    exists(CreatedSafeXmlReader safeReader | safeReader.flowsTo(this.getArgument(0))) or
    exists(ExplicitlySafeXmlReader safeReader | safeReader.flowsTo(this.getArgument(0)))
  }
}

/** DEPRECATED: Alias for ConstructedSaxSource */
deprecated class ConstructedSAXSource = ConstructedSaxSource;

/** A call to the `SAXSource.setXMLReader` method. */
class SaxSourceSetReader extends MethodAccess {
  SaxSourceSetReader() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxSource and
      m.hasName("setXMLReader")
    )
  }
}

/** DEPRECATED: Alias for SaxSourceSetReader */
deprecated class SAXSourceSetReader = SaxSourceSetReader;

/** A `SaxSource` that is safe to use. */
class SafeSaxSource extends Expr {
  SafeSaxSource() {
    exists(Variable v | v = this.(VarAccess).getVariable() |
      exists(SaxSourceSetReader s | s.getQualifier() = v.getAnAccess() |
        (
          exists(CreatedSafeXmlReader safeReader | safeReader.flowsTo(s.getArgument(0))) or
          exists(ExplicitlySafeXmlReader safeReader | safeReader.flowsTo(s.getArgument(0)))
        )
      )
    )
    or
    this.(ConstructedSaxSource).isSafe()
  }
}

/** DEPRECATED: Alias for SafeSaxSource */
deprecated class SafeSAXSource = SafeSaxSource;

/* Transformer: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#transformerfactory */
/** An access to a method use for configuring a transformer or schema. */
abstract class TransformerConfig extends MethodAccess {
  /** Holds if the configuration is disabled */
  predicate disables(Expr e) {
    this.getArgument(0) = e and
    this.getArgument(1).(StringLiteral).getValue() = ""
  }
}

/** The class `javax.xml.XMLConstants`. */
class XmlConstants extends RefType {
  XmlConstants() { this.hasQualifiedName("javax.xml", "XMLConstants") }
}

/** A configuration specific for transformers and schema. */
Expr configAccessExternalDTD() {
  result.(ConstantStringExpr).getStringValue() =
    "http://javax.xml.XMLConstants/property/accessExternalDTD"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("ACCESS_EXTERNAL_DTD") and
    f.getDeclaringType() instanceof XmlConstants
  )
}

/** A configuration specific for transformers. */
Expr configAccessExternalStyleSheet() {
  result.(ConstantStringExpr).getStringValue() =
    "http://javax.xml.XMLConstants/property/accessExternalStylesheet"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("ACCESS_EXTERNAL_STYLESHEET") and
    f.getDeclaringType() instanceof XmlConstants
  )
}

/** A configuration specific for schema. */
Expr configAccessExternalSchema() {
  result.(ConstantStringExpr).getStringValue() =
    "http://javax.xml.XMLConstants/property/accessExternalSchema"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("ACCESS_EXTERNAL_SCHEMA") and
    f.getDeclaringType() instanceof XmlConstants
  )
}

/** The class `javax.xml.transform.TransformerFactory` or `javax.xml.transform.sax.SAXTransformerFactory`. */
class TransformerFactory extends RefType {
  TransformerFactory() {
    this.hasQualifiedName("javax.xml.transform", "TransformerFactory") or
    this.hasQualifiedName("javax.xml.transform.sax", "SAXTransformerFactory")
  }
}

/** The class `javax.xml.transform.Transformer`. */
class Transformer extends RefType {
  Transformer() { this.hasQualifiedName("javax.xml.transform", "Transformer") }
}

/** A call to `Transformer.transform`. */
class TransformerTransform extends XmlParserCall {
  TransformerTransform() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof Transformer and
      m.hasName("transform")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeTransformerToTransformerTransformFlowConfig st |
      st.hasFlowToExpr(this.getQualifier())
    )
  }
}

private class SafeTransformerToTransformerTransformFlowConfig extends DataFlow2::Configuration {
  SafeTransformerToTransformerTransformFlowConfig() {
    this = "XmlParsers::SafeTransformerToTransformerTransformFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeTransformer }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(TransformerTransform tt).getQualifier()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A call to `Transformer.newTransformer` with source. */
class TransformerFactorySource extends XmlParserCall {
  TransformerFactorySource() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TransformerFactory and
      m.hasName("newTransformer")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeTransformerFactoryFlowConfig stf | stf.hasFlowToExpr(this.getQualifier()))
  }
}

/** A `ParserConfig` specific to `TransformerFactory`. */
class TransformerFactoryConfig extends TransformerConfig {
  TransformerFactoryConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof TransformerFactory and
      m.hasName("setAttribute")
    )
  }
}

/**
 * A dataflow configuration that identifies `TransformerFactory` and `SAXTransformerFactory`
 * instances that have been safely configured.
 */
class SafeTransformerFactoryFlowConfig extends DataFlow3::Configuration {
  SafeTransformerFactoryFlowConfig() { this = "XmlParsers::SafeTransformerFactoryFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeTransformerFactory }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod().getDeclaringType() instanceof TransformerFactory
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A safely configured `TransformerFactory`. */
class SafeTransformerFactory extends VarAccess {
  SafeTransformerFactory() {
    exists(Variable v | v = this.getVariable() |
      exists(TransformerFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalDTD())
      ) and
      exists(TransformerFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalStyleSheet())
      )
    )
  }
}

/** A `Transformer` created from a safely configured `TranformerFactory`. */
class SafeTransformer extends MethodAccess {
  SafeTransformer() {
    exists(SafeTransformerFactoryFlowConfig stf, Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TransformerFactory and
      m.hasName("newTransformer") and
      stf.hasFlowToExpr(this.getQualifier())
    )
  }
}

/*
 * SAXTransformer: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#saxtransformerfactory
 * Has an extra method called newFilter.
 */

/** A call to `SAXTransformerFactory.newFilter`. */
class SaxTransformerFactoryNewXmlFilter extends XmlParserCall {
  SaxTransformerFactoryNewXmlFilter() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType().hasQualifiedName("javax.xml.transform.sax", "SAXTransformerFactory") and
      m.hasName("newXMLFilter")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeTransformerFactoryFlowConfig stf | stf.hasFlowToExpr(this.getQualifier()))
  }
}

/** DEPRECATED: Alias for SaxTransformerFactoryNewXmlFilter */
deprecated class SAXTransformerFactoryNewXMLFilter = SaxTransformerFactoryNewXmlFilter;

/* Schema: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#schemafactory */
/** The class `javax.xml.validation.SchemaFactory`. */
class SchemaFactory extends RefType {
  SchemaFactory() { this.hasQualifiedName("javax.xml.validation", "SchemaFactory") }
}

/** A `ParserConfig` specific to `SchemaFactory`. */
class SchemaFactoryConfig extends TransformerConfig {
  SchemaFactoryConfig() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof SchemaFactory and
      m.hasName("setProperty")
    )
  }
}

/** A call to `SchemaFactory.newSchema`. */
class SchemaFactoryNewSchema extends XmlParserCall {
  SchemaFactoryNewSchema() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof SchemaFactory and
      m.hasName("newSchema")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeSchemaFactoryToSchemaFactoryNewSchemaFlowConfig ssf |
      ssf.hasFlowToExpr(this.getQualifier())
    )
  }
}

private class SafeSchemaFactoryToSchemaFactoryNewSchemaFlowConfig extends DataFlow2::Configuration {
  SafeSchemaFactoryToSchemaFactoryNewSchemaFlowConfig() {
    this = "XmlParsers::SafeSchemaFactoryToSchemaFactoryNewSchemaFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSchemaFactory }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(SchemaFactoryNewSchema sfns).getQualifier()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A safely configured `SchemaFactory`. */
class SafeSchemaFactory extends VarAccess {
  SafeSchemaFactory() {
    exists(Variable v | v = this.getVariable() |
      exists(SchemaFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalDTD())
      ) and
      exists(SchemaFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalSchema())
      )
    )
  }
}

/* Unmarshaller: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#jaxb-unmarshaller */
/** The class `javax.xml.bind.Unmarshaller`. */
class XmlUnmarshaller extends RefType {
  XmlUnmarshaller() { this.hasQualifiedName("javax.xml.bind", "Unmarshaller") }
}

/** A call to `Unmarshaller.unmarshal`. */
class XmlUnmarshal extends XmlParserCall {
  XmlUnmarshal() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XmlUnmarshaller and
      m.hasName("unmarshal")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

/* XPathExpression: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#xpathexpression */
/** The class `javax.xml.xpath.XPathExpression`. */
class XPathExpression extends RefType {
  XPathExpression() { this.hasQualifiedName("javax.xml.xpath", "XPathExpression") }
}

/** A call to `XPathExpression.evaluate`. */
class XPathEvaluate extends XmlParserCall {
  XPathEvaluate() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XPathExpression and
      m.hasName("evaluate")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

// Sink methods in simplexml http://simple.sourceforge.net/home.php
/** A call to `read` or `validate` in `Persister`. */
class SimpleXmlPersisterCall extends XmlParserCall {
  SimpleXmlPersisterCall() {
    exists(Method m |
      this.getMethod() = m and
      (m.hasName("validate") or m.hasName("read")) and
      m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.core", "Persister")
    )
  }

  override Expr getSink() { result = this.getArgument(1) }

  override predicate isSafe() { none() }
}

/** DEPRECATED: Alias for SimpleXmlPersisterCall */
deprecated class SimpleXMLPersisterCall = SimpleXmlPersisterCall;

/** A call to `provide` in `Provider`. */
class SimpleXmlProviderCall extends XmlParserCall {
  SimpleXmlProviderCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("provide") and
      (
        m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.stream", "DocumentProvider") or
        m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.stream", "StreamProvider")
      )
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

/** DEPRECATED: Alias for SimpleXmlProviderCall */
deprecated class SimpleXMLProviderCall = SimpleXmlProviderCall;

/** A call to `read` in `NodeBuilder`. */
class SimpleXmlNodeBuilderCall extends XmlParserCall {
  SimpleXmlNodeBuilderCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("read") and
      m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.stream", "NodeBuilder")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

/** DEPRECATED: Alias for SimpleXmlNodeBuilderCall */
deprecated class SimpleXMLNodeBuilderCall = SimpleXmlNodeBuilderCall;

/** A call to the `format` method of the `Formatter`. */
class SimpleXmlFormatterCall extends XmlParserCall {
  SimpleXmlFormatterCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("format") and
      m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.stream", "Formatter")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

/** DEPRECATED: Alias for SimpleXmlFormatterCall */
deprecated class SimpleXMLFormatterCall = SimpleXmlFormatterCall;

/** A configuration for secure processing. */
Expr configSecureProcessing() {
  result.(ConstantStringExpr).getStringValue() =
    "http://javax.xml.XMLConstants/feature/secure-processing"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("FEATURE_SECURE_PROCESSING") and
    f.getDeclaringType() instanceof XmlConstants
  )
}
