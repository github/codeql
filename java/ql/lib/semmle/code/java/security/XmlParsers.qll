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
    SafeDocumentBuilderToDocumentBuilderParseFlow::flowToExpr(this.getQualifier())
  }
}

private module SafeDocumentBuilderToDocumentBuilderParseFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeDocumentBuilder }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(DocumentBuilderParse dbp).getQualifier()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
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

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeDocumentBuilderToDocumentBuilderParseFlow =
  DataFlow::Global<SafeDocumentBuilderToDocumentBuilderParseFlowConfig>;

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

private module SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlowConfig implements
  DataFlow::ConfigSig
{
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeDocumentBuilderFactory }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(DocumentBuilderConstruction dbc).getQualifier()
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlow =
  DataFlow::Global<SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlowConfig>;

/**
 * A `DocumentBuilder` created from a safely configured `DocumentBuilderFactory`.
 */
class SafeDocumentBuilder extends DocumentBuilderConstruction {
  SafeDocumentBuilder() {
    SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlow::flowToExpr(this.getQualifier())
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
    SafeXmlInputFactoryToXmlInputFactoryReaderFlow::flowToExpr(this.getQualifier())
  }
}

private module SafeXmlInputFactoryToXmlInputFactoryReaderFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeXmlInputFactory }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(XmlInputFactoryStreamReader xifsr).getQualifier() or
    sink.asExpr() = any(XmlInputFactoryEventReader xifer).getQualifier()
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeXmlInputFactoryToXmlInputFactoryReaderFlow =
  DataFlow::Global<SafeXmlInputFactoryToXmlInputFactoryReaderFlowConfig>;

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
    SafeXmlInputFactoryToXmlInputFactoryReaderFlow::flowToExpr(this.getQualifier())
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
Expr configOptionSupportDtd() {
  result.(ConstantStringExpr).getStringValue() = "javax.xml.stream.supportDTD"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("SUPPORT_DTD") and
    f.getDeclaringType() instanceof XmlInputFactory
  )
}

/** DEPRECATED: Alias for configOptionSupportDtd */
deprecated Expr configOptionSupportDTD() { result = configOptionSupportDtd() }

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
        config.disables(configOptionSupportDtd())
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
    SafeSaxBuilderToSaxBuilderParseFlow::flowToExpr(this.getQualifier())
  }
}

/** DEPRECATED: Alias for SaxBuilderParse */
deprecated class SAXBuilderParse = SaxBuilderParse;

private module SafeSaxBuilderToSaxBuilderParseFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxBuilder }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(SaxBuilderParse sax).getQualifier() }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeSaxBuilderToSaxBuilderParseFlow =
  DataFlow::Global<SafeSaxBuilderToSaxBuilderParseFlowConfig>;

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

  override predicate isSafe() { SafeSaxParserFlow::flowToExpr(this.getQualifier()) }
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

private module SafeSaxParserFactoryToNewSaxParserFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxParserFactory }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() = m and
      m.getDeclaringType() instanceof SaxParserFactory and
      m.hasName("newSAXParser")
    )
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeSaxParserFactoryToNewSaxParserFlow =
  DataFlow::Global<SafeSaxParserFactoryToNewSaxParserFlowConfig>;

private module SafeSaxParserFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxParser }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof SaxParser
    )
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeSaxParserFlow = DataFlow::Global<SafeSaxParserFlowConfig>;

/** A `SaxParser` created from a safely configured `SaxParserFactory`. */
class SafeSaxParser extends MethodAccess {
  SafeSaxParser() {
    this.getMethod().getDeclaringType() instanceof SaxParserFactory and
    this.getMethod().hasName("newSAXParser") and
    SafeSaxParserFactoryToNewSaxParserFlow::flowToExpr(this.getQualifier())
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

  override predicate isSafe() { SafeSaxReaderFlow::flowToExpr(this.getQualifier()) }
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

private module SafeSaxReaderFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSaxReader }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof SaxReader
    )
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeSaxReaderFlow = DataFlow::Global<SafeSaxReaderFlowConfig>;

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

private module ExplicitlySafeXmlReaderFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ExplicitlySafeXmlReader }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SafeXmlReaderFlowSink }

  int fieldFlowBranchLimit() { result = 0 }
}

private module ExplicitlySafeXmlReaderFlow = DataFlow::Global<ExplicitlySafeXmlReaderFlowConfig>;

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
    ExplicitlySafeXmlReaderFlow::flow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
  }
}

/** DEPRECATED: Alias for ExplicitlySafeXmlReader */
deprecated class ExplicitlySafeXMLReader = ExplicitlySafeXmlReader;

private module CreatedSafeXmlReaderFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CreatedSafeXmlReader }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SafeXmlReaderFlowSink }

  int fieldFlowBranchLimit() { result = 0 }
}

private module CreatedSafeXmlReaderFlow = DataFlow::Global<CreatedSafeXmlReaderFlowConfig>;

/** An `XmlReader` that is obtained from a safe source. */
class CreatedSafeXmlReader extends Call {
  CreatedSafeXmlReader() {
    //Obtained from SAXParser
    this.(MethodAccess).getMethod().getDeclaringType() instanceof SaxParser and
    this.(MethodAccess).getMethod().hasName("getXMLReader") and
    SafeSaxParserFlow::flowToExpr(this.getQualifier())
    or
    //Obtained from SAXReader
    this.(MethodAccess).getMethod().getDeclaringType() instanceof SaxReader and
    this.(MethodAccess).getMethod().hasName("getXMLReader") and
    SafeSaxReaderFlow::flowToExpr(this.getQualifier())
    or
    exists(RefType secureReader, string package |
      this.(ClassInstanceExpr).getConstructedType() = secureReader and
      secureReader.hasQualifiedName(package, "SecureJDKXercesXMLReader") and
      package.matches("com.google.%common.xml.parsing")
    )
  }

  /** Holds if `CreatedSafeXmlReaderFlowConfig` detects flow from this to `sink` */
  predicate flowsTo(SafeXmlReaderFlowSink sink) {
    CreatedSafeXmlReaderFlow::flow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
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
Expr configAccessExternalDtd() {
  result.(ConstantStringExpr).getStringValue() =
    "http://javax.xml.XMLConstants/property/accessExternalDTD"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("ACCESS_EXTERNAL_DTD") and
    f.getDeclaringType() instanceof XmlConstants
  )
}

/** DEPRECATED: Alias for configAccessExternalDtd */
deprecated Expr configAccessExternalDTD() { result = configAccessExternalDtd() }

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
    SafeTransformerToTransformerTransformFlow::flowToExpr(this.getQualifier())
  }
}

private module SafeTransformerToTransformerTransformFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeTransformer }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(TransformerTransform tt).getQualifier()
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeTransformerToTransformerTransformFlow =
  DataFlow::Global<SafeTransformerToTransformerTransformFlowConfig>;

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

  override predicate isSafe() { SafeTransformerFactoryFlow::flowToExpr(this.getQualifier()) }
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
 * DEPRECATED: Use `SafeTransformerFactoryFlow` instead.
 *
 * A dataflow configuration that identifies `TransformerFactory` and `SAXTransformerFactory`
 * instances that have been safely configured.
 */
deprecated class SafeTransformerFactoryFlowConfig extends DataFlow3::Configuration {
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

/**
 * A dataflow configuration that identifies `TransformerFactory` and `SAXTransformerFactory`
 * instances that have been safely configured.
 */
module SafeTransformerFactoryFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeTransformerFactory }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod().getDeclaringType() instanceof TransformerFactory
    )
  }

  int fieldFlowBranchLimit() { result = 0 }
}

/**
 * Identifies `TransformerFactory` and `SAXTransformerFactory`
 * instances that have been safely configured.
 */
module SafeTransformerFactoryFlow = DataFlow::Global<SafeTransformerFactoryFlowConfig>;

/** A safely configured `TransformerFactory`. */
class SafeTransformerFactory extends VarAccess {
  SafeTransformerFactory() {
    exists(Variable v | v = this.getVariable() |
      exists(TransformerFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalDtd())
      ) and
      exists(TransformerFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalStyleSheet())
      )
    )
  }
}

/** A `Transformer` created from a safely configured `TransformerFactory`. */
class SafeTransformer extends MethodAccess {
  SafeTransformer() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TransformerFactory and
      m.hasName("newTransformer") and
      SafeTransformerFactoryFlow::flowToExpr(this.getQualifier())
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

  override predicate isSafe() { SafeTransformerFactoryFlow::flowToExpr(this.getQualifier()) }
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
    SafeSchemaFactoryToSchemaFactoryNewSchemaFlow::flowToExpr(this.getQualifier())
  }
}

private module SafeSchemaFactoryToSchemaFactoryNewSchemaFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSchemaFactory }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(SchemaFactoryNewSchema sfns).getQualifier()
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeSchemaFactoryToSchemaFactoryNewSchemaFlow =
  DataFlow::Global<SafeSchemaFactoryToSchemaFactoryNewSchemaFlowConfig>;

/** A safely configured `SchemaFactory`. */
class SafeSchemaFactory extends VarAccess {
  SafeSchemaFactory() {
    exists(Variable v | v = this.getVariable() |
      exists(SchemaFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config.disables(configAccessExternalDtd())
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
