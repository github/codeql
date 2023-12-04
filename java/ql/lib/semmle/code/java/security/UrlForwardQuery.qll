/** Provides a taint-tracking configuration for reasoning about URL forwarding. */

import java
import semmle.code.java.security.UrlForward
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.PathSanitizer

/**
 * A taint-tracking configuration for reasoning about URL forwarding.
 */
module UrlForwardFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ThreatModelFlowSource and
    // excluded due to FPs
    not exists(MethodCall mc, Method m | mc.getMethod() = m |
      (
        m instanceof HttpServletRequestGetRequestUriMethod or
        m instanceof HttpServletRequestGetRequestUrlMethod or
        m instanceof HttpServletRequestGetPathMethod
      ) and
      mc = source.asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlForwardSink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof UrlForwardBarrier or
    node instanceof PathInjectionSanitizer
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

/**
 * Taint-tracking flow for URL forwarding.
 */
module UrlForwardFlow = TaintTracking::Global<UrlForwardFlowConfig>;
