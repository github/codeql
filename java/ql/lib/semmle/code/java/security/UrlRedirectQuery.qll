/** Provides a taint-tracking configuration for reasoning about URL redirections. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.UrlRedirect

/**
 * A taint-tracking configuration for reasoning about URL redirections.
 */
module UrlRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

/**
 * Taint-tracking flow for URL redirections.
 */
module UrlRedirectFlow = TaintTracking::Global<UrlRedirectConfig>;
