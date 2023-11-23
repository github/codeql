/** Provides classes to reason about XSLT injection vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A data flow sink for unvalidated user input that is used in XSLT transformation.
 * Extend this class to add your own XSLT Injection sinks.
 */
abstract class XsltInjectionSink extends DataFlow::Node { }

/** A default sink representing methods susceptible to XSLT Injection attacks. */
private class DefaultXsltInjectionSink extends XsltInjectionSink {
  DefaultXsltInjectionSink() { sinkNode(this, "xslt-injection") }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `XsltInjectionFlowConfig`.
 */
class XsltInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `XsltInjectionFlowConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A set of additional taint steps to consider when taint tracking XSLT related data flows. */
private class DefaultXsltInjectionAdditionalTaintStep extends XsltInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    xmlStreamReaderStep(node1, node2) or
    xmlEventReaderStep(node1, node2) or
    staxSourceStep(node1, node2) or
    documentBuilderStep(node1, node2) or
    domSourceStep(node1, node2) or
    newTransformerFromTemplatesStep(node1, node2) or
    xsltCompilerStep(node1, node2) or
    xsltExecutableStep(node1, node2) or
    xsltPackageStep(node1, node2)
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `InputStream` or `Reader` and
 * `XMLStreamReader`, i.e. `XMLInputFactory.createXMLStreamReader(tainted)`.
 */
private predicate xmlStreamReaderStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(XmlInputFactoryStreamReader xmlStreamReader |
    if xmlStreamReader.getMethod().getParameterType(0) instanceof TypeString
    then n1.asExpr() = xmlStreamReader.getArgument(1)
    else n1.asExpr() = xmlStreamReader.getArgument(0)
  |
    n2.asExpr() = xmlStreamReader
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `InputStream` or `Reader` and
 * `XMLEventReader`, i.e. `XMLInputFactory.createXMLEventReader(tainted)`.
 */
private predicate xmlEventReaderStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(XmlInputFactoryEventReader xmlEventReader |
    if xmlEventReader.getMethod().getParameterType(0) instanceof TypeString
    then n1.asExpr() = xmlEventReader.getArgument(1)
    else n1.asExpr() = xmlEventReader.getArgument(0)
  |
    n2.asExpr() = xmlEventReader
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `XMLStreamReader` or
 * `XMLEventReader` and `StAXSource`, i.e. `new StAXSource(tainted)`.
 */
private predicate staxSourceStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeStAXSource |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `InputStream` and `Document`,
 * i.e. `DocumentBuilder.parse(tainted)`.
 */
private predicate documentBuilderStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(DocumentBuilderParse documentBuilder |
    n1.asExpr() = documentBuilder.getArgument(0) and
    n2.asExpr() = documentBuilder
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Document` and `DOMSource`, i.e.
 * `new DOMSource(tainted)`.
 */
private predicate domSourceStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeDomSource |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Templates` and `Transformer`,
 * i.e. `tainted.newTransformer()`.
 */
private predicate newTransformerFromTemplatesStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodCall ma, Method m | ma.getMethod() = m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma and
    m.getDeclaringType() instanceof TypeTemplates and
    m.hasName("newTransformer")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Source` or `URI` and
 * `XsltExecutable` or `XsltPackage`, i.e. `XsltCompiler.compile(tainted)` or
 * `XsltCompiler.loadExecutablePackage(tainted)` or `XsltCompiler.compilePackage(tainted)` or
 * `XsltCompiler.loadLibraryPackage(tainted)`.
 */
private predicate xsltCompilerStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodCall ma, Method m | ma.getMethod() = m |
    n1.asExpr() = ma.getArgument(0) and
    n2.asExpr() = ma and
    m.getDeclaringType() instanceof TypeXsltCompiler and
    m.hasName(["compile", "loadExecutablePackage", "compilePackage", "loadLibraryPackage"])
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `XsltExecutable` and
 * `XsltTransformer` or `Xslt30Transformer`, i.e. `XsltExecutable.load()` or
 * `XsltExecutable.load30()`.
 */
private predicate xsltExecutableStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodCall ma, Method m | ma.getMethod() = m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma and
    m.getDeclaringType() instanceof TypeXsltExecutable and
    m.hasName(["load", "load30"])
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `XsltPackage` and
 * `XsltExecutable`, i.e. `XsltPackage.link()`.
 */
private predicate xsltPackageStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodCall ma, Method m | ma.getMethod() = m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma and
    m.getDeclaringType() instanceof TypeXsltPackage and
    m.hasName("link")
  )
}

/** The class `javax.xml.transform.stax.StAXSource`. */
private class TypeStAXSource extends Class {
  TypeStAXSource() { this.hasQualifiedName("javax.xml.transform.stax", "StAXSource") }
}

/** The class `javax.xml.transform.dom.DOMSource`. */
private class TypeDomSource extends Class {
  TypeDomSource() { this.hasQualifiedName("javax.xml.transform.dom", "DOMSource") }
}

/** The interface `javax.xml.transform.Templates`. */
private class TypeTemplates extends Interface {
  TypeTemplates() { this.hasQualifiedName("javax.xml.transform", "Templates") }
}

/** The class `net.sf.saxon.s9api.XsltCompiler`. */
private class TypeXsltCompiler extends Class {
  TypeXsltCompiler() { this.hasQualifiedName("net.sf.saxon.s9api", "XsltCompiler") }
}

/** The class `net.sf.saxon.s9api.XsltExecutable`. */
private class TypeXsltExecutable extends Class {
  TypeXsltExecutable() { this.hasQualifiedName("net.sf.saxon.s9api", "XsltExecutable") }
}

/** The class `net.sf.saxon.s9api.XsltPackage`. */
private class TypeXsltPackage extends Class {
  TypeXsltPackage() { this.hasQualifiedName("net.sf.saxon.s9api", "XsltPackage") }
}

// XmlParsers classes
/** A call to `DocumentBuilder.parse`. */
private class DocumentBuilderParse extends MethodCall {
  DocumentBuilderParse() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof DocumentBuilder and
      m.hasName("parse")
    )
  }
}

/** The class `javax.xml.parsers.DocumentBuilder`. */
private class DocumentBuilder extends RefType {
  DocumentBuilder() { this.hasQualifiedName("javax.xml.parsers", "DocumentBuilder") }
}

/** A call to `XMLInputFactory.createXMLStreamReader`. */
private class XmlInputFactoryStreamReader extends MethodCall {
  XmlInputFactoryStreamReader() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XmlInputFactory and
      m.hasName("createXMLStreamReader")
    )
  }
}

/** A call to `XMLInputFactory.createEventReader`. */
private class XmlInputFactoryEventReader extends MethodCall {
  XmlInputFactoryEventReader() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof XmlInputFactory and
      m.hasName("createXMLEventReader")
    )
  }
}

/** The class `javax.xml.stream.XMLInputFactory`. */
private class XmlInputFactory extends RefType {
  XmlInputFactory() { this.hasQualifiedName("javax.xml.stream", "XMLInputFactory") }
}
