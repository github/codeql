/**
 * Provides a taint-tracking configuration characterising request-forgery risks.
 *
 * Only import this directly from .ql files, to avoid the possibility of polluting the Configuration hierarchy accidentally.
 */

import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.RequestForgery

/**
 * A taint-tracking configuration characterising request-forgery risks.
 */
module RequestForgeryConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ActiveThreatModelSource and
    // Exclude results of remote HTTP requests: fetching something else based on that result
    // is no worse than following a redirect returned by the remote server, and typically
    // we're requesting a resource via https which we trust to only send us to safe URLs.
    not source.asExpr().(MethodCall).getCallee() instanceof UrlConnectionGetInputStreamMethod
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof RequestForgerySink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(RequestForgeryAdditionalTaintStep r).propagatesTaint(pred, succ)
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof RequestForgerySanitizer }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module RequestForgeryFlow = TaintTracking::Global<RequestForgeryConfig>;
