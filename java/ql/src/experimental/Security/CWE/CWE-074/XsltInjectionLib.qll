import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XmlParsers
import DataFlow

/**
 * A taint-tracking configuration for unvalidated user input that is used in XSLT transformation.
 */
class XsltInjectionFlowConfig extends TaintTracking::Configuration {
  XsltInjectionFlowConfig() { this = "XsltInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XsltInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    xmlStreamReaderStep(node1, node2) or
    xmlEventReaderStep(node1, node2) or
    staxSourceStep(node1, node2) or
    documentBuilderStep(node1, node2) or
    domSourceStep(node1, node2) or
    newTransformerOrTemplatesStep(node1, node2) or
    newTransformerFromTemplatesStep(node1, node2)
  }
}

/** The class `javax.xml.transform.stax.StAXSource`. */
class TypeStAXSource extends Class {
  TypeStAXSource() { this.hasQualifiedName("javax.xml.transform.stax", "StAXSource") }
}

/** The class `javax.xml.transform.dom.DOMSource`. */
class TypeDOMSource extends Class {
  TypeDOMSource() { this.hasQualifiedName("javax.xml.transform.dom", "DOMSource") }
}

/** The interface `javax.xml.transform.Templates`. */
class TypeTemplates extends Interface {
  TypeTemplates() { this.hasQualifiedName("javax.xml.transform", "Templates") }
}

/** A data flow sink for unvalidated user input that is used in XSLT transformation. */
class XsltInjectionSink extends DataFlow::ExprNode {
  XsltInjectionSink() {
    exists(MethodAccess ma |
      ma.getQualifier() = this.getExpr() and
      ma instanceof TransformerTransform
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `InputStream` or `Reader` and
 * `XMLStreamReader`, i.e. `XMLInputFactory.createXMLStreamReader(tainted)`.
 */
predicate xmlStreamReaderStep(ExprNode n1, ExprNode n2) {
  exists(XmlInputFactoryStreamReader xmlStreamReader |
    n1.asExpr() = xmlStreamReader.getSink() and
    n2.asExpr() = xmlStreamReader
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `InputStream` or `Reader` and
 * `XMLEventReader`, i.e. `XMLInputFactory.createXMLEventReader(tainted)`.
 */
predicate xmlEventReaderStep(ExprNode n1, ExprNode n2) {
  exists(XmlInputFactoryEventReader xmlEventReader |
    n1.asExpr() = xmlEventReader.getSink() and
    n2.asExpr() = xmlEventReader
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `XMLStreamReader` or
 * `XMLEventReader` and `StAXSource`, i.e. `new StAXSource(tainted)`.
 */
predicate staxSourceStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeStAXSource |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `InputStream` and `Document`,
 * i.e. `DocumentBuilder.parse(tainted)`.
 */
predicate documentBuilderStep(ExprNode n1, ExprNode n2) {
  exists(DocumentBuilderParse documentBuilder |
    n1.asExpr() = documentBuilder.getSink() and
    n2.asExpr() = documentBuilder
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Document` and `DOMSource`, i.e.
 * `new DOMSource(tainted)`.
 */
predicate domSourceStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeDOMSource |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
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
 * Holds if `n1` to `n2` is a dataflow step that converts between `Source` and `Transformer` or
 * `Templates`, i.e. `TransformerFactory.newTransformer(tainted)` or
 * `TransformerFactory.newTemplates(tainted)`.
 */
predicate newTransformerOrTemplatesStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    n1.asExpr() = ma.getAnArgument() and
    n2.asExpr() = ma and
    (
      m.getDeclaringType() instanceof TransformerFactory and m.hasName("newTransformer")
      or
      m.getDeclaringType() instanceof TransformerFactory and m.hasName("newTemplates")
    ) and
    not exists(TransformerFactoryWithSecureProcessingFeatureFlowConfig conf |
      conf.hasFlowToExpr(ma.getQualifier())
    )
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Templates` and `Transformer`,
 * i.e. `tainted.newTransformer()`.
 */
predicate newTransformerFromTemplatesStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma and
    m.getDeclaringType() instanceof TypeTemplates and
    m.hasName("newTransformer")
  )
}
