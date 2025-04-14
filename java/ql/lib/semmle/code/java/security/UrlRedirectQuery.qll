/** Provides a taint-tracking configuration for reasoning about URL redirections. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.UrlRedirect

/**
 * A taint-tracking configuration for reasoning about URL redirections.
 */
module UrlRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof UrlRedirectSanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking flow for URL redirections.
 */
module UrlRedirectFlow = TaintTracking::Global<UrlRedirectConfig>;
