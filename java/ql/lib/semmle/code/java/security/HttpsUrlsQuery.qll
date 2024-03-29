/** Provides taint tracking configurations to be used in HTTPS URLs queries. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Networking
import semmle.code.java.security.HttpsUrls
private import semmle.code.java.security.Sanitizers

/**
 * DEPRECATED: Use `HttpsStringToUrlOpenMethodFlow` instead.
 *
 * A taint tracking configuration for HTTP connections.
 */
deprecated class HttpStringToUrlOpenMethodFlowConfig extends TaintTracking::Configuration {
  HttpStringToUrlOpenMethodFlowConfig() { this = "HttpStringToUrlOpenMethodFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HttpStringLiteral }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlOpenSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(HttpUrlsAdditionalTaintStep c).step(node1, node2)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

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
