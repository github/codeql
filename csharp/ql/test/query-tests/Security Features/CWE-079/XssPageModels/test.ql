import csharp
import semmle.code.csharp.security.dataflow.XSSQuery
import semmle.code.csharp.security.dataflow.XSSSinks

module TestXssTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(MethodCall).getTarget().getName() = "source"
  }

  predicate isSink = XssTrackingConfig::isSink/1;

  predicate isBarrier = XssTrackingConfig::isBarrier/1;
}

module TestXss = TaintTracking::Global<TestXssTrackingConfig>;

from DataFlow::Node source, DataFlow::Node sink
where TestXss::flow(source, sink)
select sink, source, sink, "Xss"
