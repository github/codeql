/** Provides a taint-tracking configuration to reason about URL redirection from local sources. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.UrlRedirect

/**
 * A taint-tracking configuration to reason about URL redirection from local sources.
 */
module UrlRedirectLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

/**
 * Taint-tracking flow for URL redirection from local sources.
 */
module UrlRedirectLocalFlow = TaintTracking::Global<UrlRedirectLocalConfig>;
