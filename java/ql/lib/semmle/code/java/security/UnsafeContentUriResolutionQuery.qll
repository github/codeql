/** Provides taint tracking configurations to be used in unsafe content URI resolution queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.UnsafeContentUriResolution

/**
 * A taint-tracking configuration to find paths from remote sources to content URI resolutions.
 */
module UnsafeContentResolutionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ContentUriResolutionSink }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer instanceof ContentUriResolutionSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(ContentUriResolutionAdditionalTaintStep s).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Taint-tracking flow to find paths from remote sources to content URI resolutions. */
module UnsafeContentResolutionFlow = TaintTracking::Global<UnsafeContentResolutionConfig>;
