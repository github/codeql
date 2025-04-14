import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.QueryInjection
import utils.test.InlineExpectationsTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(MethodCall).getMethod().hasName("taint")
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(ReturnStmt r).getResult() }
}

module Flow = TaintTracking::Global<Config>;

module FlowStepTest implements TestSig {
  string getARelevantTag() { result = "taintReachesReturn" }

  predicate hasActualResult(Location l, string element, string tag, string value) {
    tag = "taintReachesReturn" and
    value = "" and
    exists(DataFlow::Node source | Flow::flow(source, _) |
      l = source.getLocation() and
      element = source.toString()
    )
  }
}

import MakeTest<FlowStepTest>
