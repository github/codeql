/** Provides taint tracking configurations to be used in Insecure Basic Authentication queries. */

import java
import semmle.code.java.security.HttpsUrls
import semmle.code.java.security.InsecureBasicAuth
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint tracking configuration for the Basic authentication scheme
 * being used in HTTP connections.
 */
class BasicAuthFlowConfig extends TaintTracking::Configuration {
  BasicAuthFlowConfig() { this = "InsecureBasicAuth::BasicAuthFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof InsecureBasicAuthSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof InsecureBasicAuthSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(HttpUrlsAdditionalTaintStep c).step(node1, node2)
  }
}
