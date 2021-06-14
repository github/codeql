/** Provides classes to reason about XSLT injection vulnerabilities. */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.security.XmlParsers
import semmle.code.java.dataflow.DataFlow

/**
 * A data flow sink for unvalidated user input that is used in XSLT transformation.
 * Extend this class to add your own XSLT Injection sinks.
 */
abstract class XsltInjectionSink extends DataFlow::Node { }

private class DefaultXsltInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.xml.transform;Transformer;false;transform;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;XsltTransformer;false;transform;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;transform;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;applyTemplates;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;callFunction;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;callTemplate;;;Argument[-1];xslt"
      ]
  }
}

/** A default sink representing methods susceptible to XSLT Injection attacks. */
private class DefaultXsltInjectionSink extends XsltInjectionSink {
  DefaultXsltInjectionSink() { sinkNode(this, "xslt") }
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
    newTransformerOrTemplatesStep(node1, node2) or
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
    n1.asExpr() = xmlStreamReader.getSink() and
    n2.asExpr() = xmlStreamReader
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `InputStream` or `Reader` and
 * `XMLEventReader`, i.e. `XMLInputFactory.createXMLEventReader(tainted)`.
 */
private predicate xmlEventReaderStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(XmlInputFactoryEventReader xmlEventReader |
    n1.asExpr() = xmlEventReader.getSink() and
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
    n1.asExpr() = documentBuilder.getSink() and
    n2.asExpr() = documentBuilder
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Document` and `DOMSource`, i.e.
 * `new DOMSource(tainted)`.
 */
private predicate domSourceStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeDOMSource |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Source` and `Transformer` or
 * `Templates`, i.e. `TransformerFactory.newTransformer(tainted)` or
 * `TransformerFactory.newTemplates(tainted)`.
 */
private predicate newTransformerOrTemplatesStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    n1.asExpr() = ma.getAnArgument() and
    n2.asExpr() = ma and
    m.getDeclaringType() instanceof TransformerFactory and
    m.hasName(["newTransformer", "newTemplates"]) and
    not exists(TransformerFactoryWithSecureProcessingFeatureFlowConfig conf |
      conf.hasFlowToExpr(ma.getQualifier())
    )
  )
}

/**
 * A data flow configuration for secure processing feature that is enabled on `TransformerFactory`.
 */
private class TransformerFactoryWithSecureProcessingFeatureFlowConfig extends DataFlow2::Configuration {
  TransformerFactoryWithSecureProcessingFeatureFlowConfig() {
    this = "TransformerFactoryWithSecureProcessingFeatureFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) {
    exists(Variable v | v = src.asExpr().(VarAccess).getVariable() |
      exists(TransformerFactoryFeatureConfig config | config.getQualifier() = v.getAnAccess() |
        config.enables(configSecureProcessing())
      )
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod().getDeclaringType() instanceof TransformerFactory
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/** A `ParserConfig` specific to `TransformerFactory`. */
private class TransformerFactoryFeatureConfig extends ParserConfig {
  TransformerFactoryFeatureConfig() {
    exists(Method m |
      m = this.getMethod() and
      m.getDeclaringType() instanceof TransformerFactory and
      m.hasName("setFeature")
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Templates` and `Transformer`,
 * i.e. `tainted.newTransformer()`.
 */
private predicate newTransformerFromTemplatesStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
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
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
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
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
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
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
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
private class TypeDOMSource extends Class {
  TypeDOMSource() { this.hasQualifiedName("javax.xml.transform.dom", "DOMSource") }
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
