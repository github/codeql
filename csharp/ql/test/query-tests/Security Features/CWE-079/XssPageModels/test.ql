/**
 * @kind path-problem
 */

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

import TestXss::PathGraph

from TestXss::PathNode source, TestXss::PathNode sink
where TestXss::flowPath(source, sink)
select sink, source, sink, "Xss"
