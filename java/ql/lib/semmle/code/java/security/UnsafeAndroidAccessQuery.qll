/** Provides taint tracking configurations to be used in Unsafe Resource Fetching queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.RequestForgery
import semmle.code.java.security.UnsafeAndroidAccess

/**
 * DEPRECATED: Use `FetchUntrustedResourceFlow` instead.
 *
 * A taint configuration tracking flow from untrusted inputs to a resource fetching call.
 */
deprecated class FetchUntrustedResourceConfiguration extends TaintTracking::Configuration {
  FetchUntrustedResourceConfiguration() { this = "FetchUntrustedResourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlResourceSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof RequestForgerySanitizer
  }
}

/**
 * A taint configuration tracking flow from untrusted inputs to a resource fetching call.
 */
module FetchUntrustedResourceConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlResourceSink }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof RequestForgerySanitizer }
}

/**
 * Detects taint flow from untrusted inputs to a resource fetching call.
 */
module FetchUntrustedResourceFlow = TaintTracking::Global<FetchUntrustedResourceConfig>;
