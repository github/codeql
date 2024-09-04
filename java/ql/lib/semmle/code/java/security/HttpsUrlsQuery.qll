/** Provides taint tracking configurations to be used in HTTPS URLs queries. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Networking
import semmle.code.java.security.HttpsUrls
private import semmle.code.java.security.Sanitizers

/**
 * A taint tracking configuration for HTTP connections.
 */
module HttpStringToUrlOpenMethodFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HttpStringLiteral }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlOpenSink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(HttpUrlsAdditionalTaintStep c).step(node1, node2)
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }
}

/**
 * Detect taint flow of HTTP connections.
 */
module HttpStringToUrlOpenMethodFlow = TaintTracking::Global<HttpStringToUrlOpenMethodFlowConfig>;
