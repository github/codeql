/** Provides taint tracking configurations to be used in unsafe content URI resolution queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.UnsafeContentUriResolution

/** A taint-tracking configuration to find paths from remote sources to content URI resolutions. */
class UnsafeContentResolutionConf extends TaintTracking::Configuration {
  UnsafeContentResolutionConf() { this = "UnsafeContentResolutionConf" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ContentUriResolutionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof ContentUriResolutionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(ContentUriResolutionAdditionalTaintStep s).step(node1, node2)
  }
}
