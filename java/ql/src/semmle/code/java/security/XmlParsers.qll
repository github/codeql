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
    this.getArgument(1).(BooleanLiteral).getBooleanValue() = false
  }

  /**
   * Holds if the method enables a property.
   */
  predicate enables(Expr e) {
    this.getArgument(0) = e and
    this.getArgument(1).(BooleanLiteral).getBooleanValue() = true
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
  or
  result.(ConstantStringExpr).getStringValue() =
    "http://javax.xml.XMLConstants/feature/secure-processing"
  or
  exists(Field f |
    result = f.getAnAccess() and
    f.hasName("FEATURE_SECURE_PROCESSING") and
    f.getDeclaringType().hasQualifiedName("javax.xml", "XMLConstants")
  )
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
class SAXBuilder extends RefType {
  SAXBuilder() {
    this.hasQualifiedName("org.jdom.input", "SAXBuilder") or
    this.hasQualifiedName("org.jdom2.input", "SAXBuilder")
  }
}

/**
 * A call to `SAXBuilder.build.`
 */
class SAXBuilderParse extends XmlParserCall {
  SAXBuilderParse() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SAXBuilder and
      m.hasName("build")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeSAXBuilderToSAXBuilderParseFlowConfig conf | conf.hasFlowToExpr(this.getQualifier()))
  }
}

private class SafeSAXBuilderToSAXBuilderParseFlowConfig extends DataFlow2::Configuration {
  SafeSAXBuilderToSAXBuilderParseFlowConfig() {
    this = "XmlParsers::SafeSAXBuilderToSAXBuilderParseFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSAXBuilder }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(SAXBuilderParse sax).getQualifier()
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/**
 * A `ParserConfig` specific to `SAXBuilder`.
 */
class SAXBuilderConfig extends ParserConfig {
  SAXBuilderConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SAXBuilder and
      m.hasName("setFeature")
    )
  }
}

/** A safely configured `SAXBuilder`. */
class SafeSAXBuilder extends VarAccess {
  SafeSAXBuilder() {
    exists(Variable v |
      v = this.getVariable() and
      exists(SAXBuilderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .enables(any(ConstantStringExpr s |
                s.getStringValue() = "http://apache.org/xml/features/disallow-doctype-decl"
              ))
      )
    )
  }
}

/*
 * The case in
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#jaxb-unmarshaller
 * will be split into two, one covers a SAXParser as a sink, the other the SAXSource as a sink.
 */

/**
 * The class `javax.xml.parsers.SAXParser`.
 */
class SAXParser extends RefType {
  SAXParser() { this.hasQualifiedName("javax.xml.parsers", "SAXParser") }
}

/** The class `javax.xml.parsers.SAXParserFactory`. */
class SAXParserFactory extends RefType {
  SAXParserFactory() { this.hasQualifiedName("javax.xml.parsers", "SAXParserFactory") }
}

/** A call to `SAXParser.parse`. */
class SAXParserParse extends XmlParserCall {
  SAXParserParse() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SAXParser and
      m.hasName("parse")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeSAXParserFlowConfig sp | sp.hasFlowToExpr(this.getQualifier()))
  }
}

/** A `ParserConfig` that is specific to `SAXParserFactory`. */
class SAXParserFactoryConfig extends ParserConfig {
  SAXParserFactoryConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SAXParserFactory and
      m.hasName("setFeature")
    )
  }
}

/**
 * A safely configured `SAXParserFactory`.
 */
class SafeSAXParserFactory extends VarAccess {
  SafeSAXParserFactory() {
    exists(Variable v | v = this.getVariable() |
      exists(SAXParserFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(SAXParserFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      ) and
      exists(SAXParserFactoryConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() =
                  "http://apache.org/xml/features/nonvalidating/load-external-dtd"
              ))
      )
    )
  }
}

private class SafeSAXParserFactoryToNewSAXParserFlowConfig extends DataFlow5::Configuration {
  SafeSAXParserFactoryToNewSAXParserFlowConfig() {
    this = "XmlParsers::SafeSAXParserFactoryToNewSAXParserFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSAXParserFactory }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() = m and
      m.getDeclaringType() instanceof SAXParserFactory and
      m.hasName("newSAXParser")
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

private class SafeSAXParserFlowConfig extends DataFlow4::Configuration {
  SafeSAXParserFlowConfig() { this = "XmlParsers::SafeSAXParserFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSAXParser }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof SAXParser
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A `SAXParser` created from a safely configured `SAXParserFactory`. */
class SafeSAXParser extends MethodAccess {
  SafeSAXParser() {
    exists(SafeSAXParserFactoryToNewSAXParserFlowConfig sdf |
      this.getMethod().getDeclaringType() instanceof SAXParserFactory and
      this.getMethod().hasName("newSAXParser") and
      sdf.hasFlowToExpr(this.getQualifier())
    )
  }
}

/* SAXReader: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#saxreader */
/**
 * The class `org.dom4j.io.SAXReader`.
 */
class SAXReader extends RefType {
  SAXReader() { this.hasQualifiedName("org.dom4j.io", "SAXReader") }
}

/** A call to `SAXReader.read`. */
class SAXReaderRead extends XmlParserCall {
  SAXReaderRead() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SAXReader and
      m.hasName("read")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(SafeSAXReaderFlowConfig sr | sr.hasFlowToExpr(this.getQualifier()))
  }
}

/** A `ParserConfig` specific to `SAXReader`. */
class SAXReaderConfig extends ParserConfig {
  SAXReaderConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SAXReader and
      m.hasName("setFeature")
    )
  }
}

private class SafeSAXReaderFlowConfig extends DataFlow4::Configuration {
  SafeSAXReaderFlowConfig() { this = "XmlParsers::SafeSAXReaderFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SafeSAXReader }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod().getDeclaringType() instanceof SAXReader
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A safely configured `SAXReader`. */
class SafeSAXReader extends VarAccess {
  SafeSAXReader() {
    exists(Variable v | v = this.getVariable() |
      exists(SAXReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(SAXReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      ) and
      exists(SAXReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .enables(any(ConstantStringExpr s |
                s.getStringValue() = "http://apache.org/xml/features/disallow-doctype-decl"
              ))
      )
    )
  }
}

/* https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#xmlreader */
/** The class `org.xml.sax.XMLReader`. */
class XMLReader extends RefType {
  XMLReader() { this.hasQualifiedName("org.xml.sax", "XMLReader") }
}

/** A call to `XMLReader.read`. */
class XMLReaderParse extends XmlParserCall {
  XMLReaderParse() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof XMLReader and
      m.hasName("parse")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    exists(ExplicitlySafeXMLReader sr | sr.flowsTo(this.getQualifier())) or
    exists(CreatedSafeXMLReader cr | cr.flowsTo(this.getQualifier()))
  }
}

/** A `ParserConfig` specific to the `XMLReader`. */
class XMLReaderConfig extends ParserConfig {
  XMLReaderConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof XMLReader and
      m.hasName("setFeature")
    )
  }
}

private class ExplicitlySafeXMLReaderFlowConfig extends DataFlow3::Configuration {
  ExplicitlySafeXMLReaderFlowConfig() { this = "XmlParsers::ExplicitlySafeXMLReaderFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof ExplicitlySafeXMLReader
  }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SafeXMLReaderFlowSink }

  override int fieldFlowBranchLimit() { result = 0 }
}

class SafeXMLReaderFlowSink extends Expr {
  SafeXMLReaderFlowSink() {
    this = any(XMLReaderParse p).getQualifier() or
    this = any(ConstructedSAXSource s).getArgument(0) or
    this = any(SAXSourceSetReader s).getArgument(0)
  }
}

/** An `XMLReader` that is explicitly configured to be safe. */
class ExplicitlySafeXMLReader extends VarAccess {
  ExplicitlySafeXMLReader() {
    exists(Variable v | v = this.getVariable() |
      exists(XMLReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-general-entities"
              ))
      ) and
      exists(XMLReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() = "http://xml.org/sax/features/external-parameter-entities"
              ))
      ) and
      exists(XMLReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .disables(any(ConstantStringExpr s |
                s.getStringValue() =
                  "http://apache.org/xml/features/nonvalidating/load-external-dtd"
              ))
      )
      or
      exists(XMLReaderConfig config | config.getQualifier() = v.getAnAccess() |
        config
            .enables(any(ConstantStringExpr s |
                s.getStringValue() = "http://apache.org/xml/features/disallow-doctype-decl"
              ))
      )
    )
  }

  predicate flowsTo(SafeXMLReaderFlowSink sink) {
    any(ExplicitlySafeXMLReaderFlowConfig conf)
        .hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
  }
}

private class CreatedSafeXMLReaderFlowConfig extends DataFlow3::Configuration {
  CreatedSafeXMLReaderFlowConfig() { this = "XmlParsers::CreatedSafeXMLReaderFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CreatedSafeXMLReader }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof SafeXMLReaderFlowSink }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** An `XMLReader` that is obtained from a safe source. */
class CreatedSafeXMLReader extends Call {
  CreatedSafeXMLReader() {
    //Obtained from SAXParser
    exists(SafeSAXParserFlowConfig safeParser |
      this.(MethodAccess).getMethod().getDeclaringType() instanceof SAXParser and
      this.(MethodAccess).getMethod().hasName("getXMLReader") and
      safeParser.hasFlowToExpr(this.getQualifier())
    )
    or
    //Obtained from SAXReader
    exists(SafeSAXReaderFlowConfig safeReader |
      this.(MethodAccess).getMethod().getDeclaringType() instanceof SAXReader and
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

  predicate flowsTo(SafeXMLReaderFlowSink sink) {
    any(CreatedSafeXMLReaderFlowConfig conf)
        .hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
  }
}

/*
 * SAXSource in
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#jaxb-unmarshaller
 */

/** The class `javax.xml.transform.sax.SAXSource` */
class SAXSource extends RefType {
  SAXSource() { this.hasQualifiedName("javax.xml.transform.sax", "SAXSource") }
}

/** A call to the constructor of `SAXSource` with `XMLReader` and `InputSource`. */
class ConstructedSAXSource extends ClassInstanceExpr {
  ConstructedSAXSource() {
    this.getConstructedType() instanceof SAXSource and
    this.getNumArgument() = 2 and
    this.getArgument(0).getType() instanceof XMLReader
  }

  /**
   * Gets the argument representing the XML content to be parsed.
   */
  Expr getSink() { result = this.getArgument(1) }

  /** Holds if the resulting `SAXSource` is safe. */
  predicate isSafe() {
    exists(CreatedSafeXMLReader safeReader | safeReader.flowsTo(this.getArgument(0))) or
    exists(ExplicitlySafeXMLReader safeReader | safeReader.flowsTo(this.getArgument(0)))
  }
}

/** A call to the `SAXSource.setXMLReader` method. */
class SAXSourceSetReader extends MethodAccess {
  SAXSourceSetReader() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SAXSource and
      m.hasName("setXMLReader")
    )
  }
}

/** A `SAXSource` that is safe to use. */
class SafeSAXSource extends Expr {
  SafeSAXSource() {
    exists(Variable v | v = this.(VarAccess).getVariable() |
      exists(SAXSourceSetReader s | s.getQualifier() = v.getAnAccess() |
        (
          exists(CreatedSafeXMLReader safeReader | safeReader.flowsTo(s.getArgument(0))) or
          exists(ExplicitlySafeXMLReader safeReader | safeReader.flowsTo(s.getArgument(0)))
        )
      )
    )
    or
    this.(ConstructedSAXSource).isSafe()
  }
}

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

private class SafeTransformerFactoryFlowConfig extends DataFlow3::Configuration {
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
class SAXTransformerFactoryNewXMLFilter extends XmlParserCall {
  SAXTransformerFactoryNewXMLFilter() {
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
class SimpleXMLPersisterCall extends XmlParserCall {
  SimpleXMLPersisterCall() {
    exists(Method m |
      this.getMethod() = m and
      (m.hasName("validate") or m.hasName("read")) and
      m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.core", "Persister")
    )
  }

  override Expr getSink() { result = this.getArgument(1) }

  override predicate isSafe() { none() }
}

/** A call to `provide` in `Provider`. */
class SimpleXMLProviderCall extends XmlParserCall {
  SimpleXMLProviderCall() {
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

/** A call to `read` in `NodeBuilder`. */
class SimpleXMLNodeBuilderCall extends XmlParserCall {
  SimpleXMLNodeBuilderCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("read") and
      m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.stream", "NodeBuilder")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

/** A call to the `format` method of the `Formatter`. */
class SimpleXMLFormatterCall extends XmlParserCall {
  SimpleXMLFormatterCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("format") and
      m.getDeclaringType().hasQualifiedName("org.simpleframework.xml.stream", "Formatter")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() { none() }
}

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
