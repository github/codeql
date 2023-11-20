import java
import semmle.code.java.security.UnsafeUrlForward
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.Jsf
import semmle.code.java.security.PathSanitizer

module UnsafeUrlForwardFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ThreatModelFlowSource and
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

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate isAdditionalFlowStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodCall ma |
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

module UnsafeUrlForwardFlow = TaintTracking::Global<UnsafeUrlForwardFlowConfig>;
