/** Provides taint tracking configurations to be used in Unsafe Resource Fetching queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.RequestForgery
import semmle.code.java.security.UnsafeAndroidAccess

/**
 * A taint configuration tracking flow from untrusted inputs to a resource fetching call.
 */
class FetchUntrustedResourceConfiguration extends TaintTracking::Configuration {
  FetchUntrustedResourceConfiguration() { this = "FetchUntrustedResourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlResourceSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof RequestForgerySanitizer
  }
}
