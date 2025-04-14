/** Provides classes and predicates for modeling XML parsers in Java. */

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.RangeUtils

private module Frameworks {
  private import semmle.code.java.frameworks.apache.CommonsXml
  private import semmle.code.java.frameworks.javaee.Xml
  private import semmle.code.java.frameworks.javase.Beans
  private import semmle.code.java.frameworks.mdht.MdhtXml
  private import semmle.code.java.frameworks.rundeck.RundeckXml
}

/**
 * An abstract type representing a call to parse XML files.
 */
abstract class XmlParserCall extends MethodCall {
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
abstract class ParserConfig extends MethodCall {
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
    SafeDocumentBuilderToDocumentBuilderParseFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

private predicate safeDocumentBuilderNode(DataFlow::Node src) {
  src.asExpr() instanceof SafeDocumentBuilder
}

private module SafeDocumentBuilderToDocumentBuilderParseFlow =
  DataFlow::SimpleGlobal<safeDocumentBuilderNode/1>;

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

private class DocumentBuilderConstruction extends MethodCall {
  DocumentBuilderConstruction() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof DocumentBuilderFactory and
      m.hasName("newDocumentBuilder")
    )
  }
}

private predicate safeDocumentBuilderFactoryNode(DataFlow::Node src) {
  src.asExpr() instanceof SafeDocumentBuilderFactory
}

private module SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlow =
  DataFlow::SimpleGlobal<safeDocumentBuilderFactoryNode/1>;

/**
 * A `DocumentBuilder` created from a safely configured `DocumentBuilderFactory`.
 */
class SafeDocumentBuilder extends DocumentBuilderConstruction {
  SafeDocumentBuilder() {
    SafeDocumentBuilderFactoryToDocumentBuilderConstructionFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
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
    SafeXmlInputFactoryToXmlInputFactoryReaderFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

private predicate safeXmlInputFactoryNode(DataFlow::Node src) {
  src.asExpr() instanceof SafeXmlInputFactory
}

private module SafeXmlInputFactoryToXmlInputFactoryReaderFlow =
  DataFlow::SimpleGlobal<safeXmlInputFactoryNode/1>;

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
    SafeXmlInputFactoryToXmlInputFactoryReaderFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
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
    SafeSaxBuilderToSaxBuilderParseFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

private predicate safeSaxBuilderNode(DataFlow::Node src) { src.asExpr() instanceof SafeSaxBuilder }

private module SafeSaxBuilderToSaxBuilderParseFlow = DataFlow::SimpleGlobal<safeSaxBuilderNode/1>;

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

/** The class `javax.xml.parsers.SAXParserFactory`. */
class SaxParserFactory extends RefType {
  SaxParserFactory() { this.hasQualifiedName("javax.xml.parsers", "SAXParserFactory") }
}

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
    SafeSaxParserFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

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

private predicate safeSaxParserFactoryNode(DataFlow::Node src) {
  src.asExpr() instanceof SafeSaxParserFactory
}

private module SafeSaxParserFactoryToNewSaxParserFlow =
  DataFlow::SimpleGlobal<safeSaxParserFactoryNode/1>;

private predicate safeSaxParserNode(DataFlow::Node src) { src.asExpr() instanceof SafeSaxParser }

private module SafeSaxParserFlow = DataFlow::SimpleGlobal<safeSaxParserNode/1>;

/** A `SaxParser` created from a safely configured `SaxParserFactory`. */
class SafeSaxParser extends MethodCall {
  SafeSaxParser() {
    this.getMethod().getDeclaringType() instanceof SaxParserFactory and
    this.getMethod().hasName("newSAXParser") and
    SafeSaxParserFactoryToNewSaxParserFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

/* SAXReader: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#saxreader */
/**
 * The class `org.dom4j.io.SAXReader`.
 */
class SaxReader extends RefType {
  SaxReader() { this.hasQualifiedName("org.dom4j.io", "SAXReader") }
}

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
    SafeSaxReaderFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

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

private predicate safeSaxReaderNode(DataFlow::Node src) { src.asExpr() instanceof SafeSaxReader }

private module SafeSaxReaderFlow = DataFlow::SimpleGlobal<safeSaxReaderNode/1>;

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

/* https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#xmlreader */
/** The class `org.xml.sax.XMLReader`. */
class XmlReader extends RefType {
  XmlReader() { this.hasQualifiedName("org.xml.sax", "XMLReader") }
}

/** The class `org.xml.sax.InputSource`. */
class InputSource extends Class {
  InputSource() { this.hasQualifiedName("org.xml.sax", "InputSource") }
}

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
    ExplicitlySafeXmlReaderFlow::flowsTo(DataFlow::exprNode(this.getQualifier())) or
    CreatedSafeXmlReaderFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

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

private predicate explicitlySafeXmlReaderNode(DataFlow::Node src) {
  src.asExpr() instanceof ExplicitlySafeXmlReader
}

private module ExplicitlySafeXmlReaderFlow = DataFlow::SimpleGlobal<explicitlySafeXmlReaderNode/1>;

/** An argument to a safe XML reader. */
class SafeXmlReaderFlowSink extends Expr {
  SafeXmlReaderFlowSink() {
    this = any(XmlReaderParse p).getQualifier() or
    this = any(ConstructedSaxSource s).getArgument(0) or
    this = any(SaxSourceSetReader s).getArgument(0)
  }
}

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
}

private predicate createdSafeXmlReaderNode(DataFlow::Node src) {
  src.asExpr() instanceof CreatedSafeXmlReader
}

private module CreatedSafeXmlReaderFlow = DataFlow::SimpleGlobal<createdSafeXmlReaderNode/1>;

/** An `XmlReader` that is obtained from a safe source. */
class CreatedSafeXmlReader extends Call {
  CreatedSafeXmlReader() {
    //Obtained from SAXParser
    this.(MethodCall).getMethod().getDeclaringType() instanceof SaxParser and
    this.(MethodCall).getMethod().hasName("getXMLReader") and
    SafeSaxParserFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
    or
    //Obtained from SAXReader
    this.(MethodCall).getMethod().getDeclaringType() instanceof SaxReader and
    this.(MethodCall).getMethod().hasName("getXMLReader") and
    SafeSaxReaderFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
    or
    exists(RefType secureReader, string package |
      this.(ClassInstanceExpr).getConstructedType() = secureReader and
      secureReader.hasQualifiedName(package, "SecureJDKXercesXMLReader") and
      package.matches("com.google.%common.xml.parsing")
    )
  }
}

/*
 * SAXSource in
 * https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#jaxb-unmarshaller
 */

/** The class `javax.xml.transform.sax.SAXSource` */
class SaxSource extends RefType {
  SaxSource() { this.hasQualifiedName("javax.xml.transform.sax", "SAXSource") }
}

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
    CreatedSafeXmlReaderFlow::flowsTo(DataFlow::exprNode(this.getArgument(0))) or
    ExplicitlySafeXmlReaderFlow::flowsTo(DataFlow::exprNode(this.getArgument(0)))
  }
}

/** A call to the `SAXSource.setXMLReader` method. */
class SaxSourceSetReader extends MethodCall {
  SaxSourceSetReader() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof SaxSource and
      m.hasName("setXMLReader")
    )
  }
}

/** A `SaxSource` that is safe to use. */
class SafeSaxSource extends Expr {
  SafeSaxSource() {
    exists(Variable v | v = this.(VarAccess).getVariable() |
      exists(SaxSourceSetReader s | s.getQualifier() = v.getAnAccess() |
        (
          CreatedSafeXmlReaderFlow::flowsTo(DataFlow::exprNode(s.getArgument(0))) or
          ExplicitlySafeXmlReaderFlow::flowsTo(DataFlow::exprNode(s.getArgument(0)))
        )
      )
    )
    or
    this.(ConstructedSaxSource).isSafe()
  }
}

/* Transformer: https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html#transformerfactory */
/** An access to a method use for configuring a transformer or schema. */
abstract class TransformerConfig extends MethodCall {
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
    SafeTransformerToTransformerTransformFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

private predicate safeTransformerNode(DataFlow::Node src) {
  src.asExpr() instanceof SafeTransformer
}

private module SafeTransformerToTransformerTransformFlow =
  DataFlow::SimpleGlobal<safeTransformerNode/1>;

/** A call to `Transformer.newTransformer` with source. */
class TransformerFactorySource extends XmlParserCall {
  TransformerFactorySource() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TransformerFactory and
      m.hasName(["newTransformer", "newTransformerHandler"])
    )
  }

  override Expr getSink() { result = this.getArgument(0) }

  override predicate isSafe() {
    SafeTransformerFactoryFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
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

private predicate safeTransformerFactoryNode(DataFlow::Node src) {
  src.asExpr() instanceof SafeTransformerFactory
}

private module SafeTransformerFactoryFlow = DataFlow::SimpleGlobal<safeTransformerFactoryNode/1>;

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
class SafeTransformer extends MethodCall {
  SafeTransformer() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TransformerFactory and
      m.hasName("newTransformer") and
      SafeTransformerFactoryFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
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
    SafeTransformerFactoryFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
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
    SafeSchemaFactoryToSchemaFactoryNewSchemaFlow::flowsTo(DataFlow::exprNode(this.getQualifier()))
  }
}

private predicate safeSchemaFactoryNode(DataFlow::Node src) {
  src.asExpr() instanceof SafeSchemaFactory
}

private module SafeSchemaFactoryToSchemaFactoryNewSchemaFlow =
  DataFlow::SimpleGlobal<safeSchemaFactoryNode/1>;

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
/** The interface `javax.xml.xpath.XPathExpression`. */
class XPathExpression extends Interface {
  XPathExpression() { this.hasQualifiedName("javax.xml.xpath", "XPathExpression") }
}

/** The interface `java.xml.xpath.XPath`. */
class XPath extends Interface {
  XPath() { this.hasQualifiedName("javax.xml.xpath", "XPath") }
}

/** A call to the method `evaluate` of the classes `XPathExpression` or `XPath`. */
class XPathEvaluate extends XmlParserCall {
  Argument sink;

  XPathEvaluate() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("evaluate")
    |
      m.getDeclaringType().getASourceSupertype*() instanceof XPathExpression and
      sink = this.getArgument(0)
      or
      m.getDeclaringType().getASourceSupertype*() instanceof XPath and
      sink = this.getArgument(1)
    )
  }

  override Expr getSink() { result = sink }

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
