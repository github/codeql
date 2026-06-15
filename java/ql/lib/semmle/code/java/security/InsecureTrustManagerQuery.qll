/** Provides taint tracking configurations to be used in Trust Manager queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.InsecureTrustManager

/**
 * A configuration to model the flow of an insecure `TrustManager`
 * to the initialization of an SSL context.
 */
module InsecureTrustManagerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof InsecureTrustManagerSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof InsecureTrustManagerSink }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    (isSink(node) or isAdditionalFlowStep(node, _)) and
    node.getType() instanceof Array and
    c instanceof DataFlow::ArrayContent
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    isSource(source) and
    (
      result = source.getLocation()
      or
      result = source.asExpr().(ClassInstanceExpr).getConstructedType().getLocation()
    )
  }
}

module InsecureTrustManagerFlow = DataFlow::Global<InsecureTrustManagerConfig>;
