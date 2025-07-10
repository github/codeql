/** Provides taint tracking configurations to be used in Insecure Basic Authentication queries. */

import java
import semmle.code.java.security.HttpsUrls
import semmle.code.java.security.InsecureBasicAuth
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint tracking configuration for the Basic authentication scheme
 * being used in HTTP connections.
 */
module BasicAuthFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof InsecureBasicAuthSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof InsecureBasicAuthSink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(HttpUrlsAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * Tracks flow for the Basic authentication scheme being used in HTTP connections.
 */
module InsecureBasicAuthFlow = TaintTracking::Global<BasicAuthFlowConfig>;
