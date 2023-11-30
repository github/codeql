/** Provides configurations to be used in queries related to unsafe URL forwarding. */

import java
import semmle.code.java.security.UnsafeUrlForward
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.PathSanitizer

/**
 * A taint-tracking configuration for untrusted user input in a URL forward or include.
 */
module UnsafeUrlForwardFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ThreatModelFlowSource and
    // TODO: move below logic to class in UnsafeUrlForward.qll?
    not exists(MethodCall ma, Method m | ma.getMethod() = m |
      (
        m instanceof HttpServletRequestGetRequestUriMethod or
        m instanceof HttpServletRequestGetRequestUrlMethod or
        m instanceof HttpServletRequestGetPathMethod
      ) and
      ma = source.asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeUrlForwardSink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof UnsafeUrlForwardSanitizer or
    node instanceof PathInjectionSanitizer
  }

  // TODO: check if the below is still needed after removing path-injection related sinks.
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

/**
 * Taint-tracking flow for untrusted user input in a URL forward or include.
 */
module UnsafeUrlForwardFlow = TaintTracking::Global<UnsafeUrlForwardFlowConfig>;
