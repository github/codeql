/** Provides a taint tracking configuration to reason about response splitting vulnerabilities. */

import java
private import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ResponseSplitting

/**
 * A taint-tracking configuration for response splitting vulnerabilities.
 */
module ResponseSplittingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ActiveThreatModelSource and
    not source instanceof SafeHeaderSplittingSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof HeaderSplittingSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof HeaderSplittingSanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Tracks flow from remote sources to response splitting vulnerabilities.
 */
module ResponseSplittingFlow = TaintTracking::Global<ResponseSplittingConfig>;
