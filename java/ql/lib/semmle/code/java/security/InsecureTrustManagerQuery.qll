/** Provides taint tracking configurations to be used in Trust Manager queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.InsecureTrustManager

/**
 * A configuration to model the flow of an insecure `TrustManager`
 * to the initialization of an SSL context.
 */
class InsecureTrustManagerConfiguration extends DataFlow::Configuration {
  InsecureTrustManagerConfiguration() { this = "InsecureTrustManagerConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof InsecureTrustManagerSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof InsecureTrustManagerSink }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    (this.isSink(node) or this.isAdditionalFlowStep(node, _)) and
    node.getType() instanceof Array and
    c instanceof DataFlow::ArrayContent
  }
}
