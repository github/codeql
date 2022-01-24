/** Provides taint tracking configurations to be used in XSLT injection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.XmlParsers
import semmle.code.java.security.XsltInjection

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
    any(XsltInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * A set of additional taint steps to consider when taint tracking XSLT related data flows.
 * These steps use data flow logic themselves.
 */
private class DataFlowXsltInjectionAdditionalTaintStep extends XsltInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    newTransformerOrTemplatesStep(node1, node2)
  }
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
