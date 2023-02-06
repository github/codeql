/**
 * @name Unsafe URL forward, dispatch, or load from remote source
 * @description URL forward, dispatch, or load based on unvalidated user-input
 *              may cause file information disclosure.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-url-forward-dispatch-load
 * @tags security
 *       experimental
 *       external/cwe-552
 */

import java
import UnsafeUrlForward
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import experimental.semmle.code.java.frameworks.Jsf
import semmle.code.java.security.PathSanitizer
import DataFlow::PathGraph

class UnsafeUrlForwardFlowConfig extends TaintTracking::Configuration {
  UnsafeUrlForwardFlowConfig() { this = "UnsafeUrlForwardFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not exists(MethodAccess ma, Method m | ma.getMethod() = m |
      (
        m instanceof HttpServletRequestGetRequestUriMethod or
        m instanceof HttpServletRequestGetRequestUrlMethod or
        m instanceof HttpServletRequestGetPathMethod
      ) and
      ma = source.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeUrlForwardSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof UnsafeUrlForwardSanitizer or
    node instanceof PathInjectionSanitizer
  }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }

  override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof GetServletResourceMethod or
        ma.getMethod() instanceof GetFacesResourceMethod or
        ma.getMethod() instanceof GetClassResourceMethod or
        ma.getMethod() instanceof GetClassLoaderResourceMethod or
        ma.getMethod() instanceof GetWildflyResourceMethod
      ) and
      ma.getArgument(0) = prev.asExpr() and
      ma = succ.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeUrlForwardFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL forward due to $@.",
  source.getNode(), "user-provided value"
