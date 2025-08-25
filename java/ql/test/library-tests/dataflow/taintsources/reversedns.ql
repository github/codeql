import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineExpectationsTest

predicate isTestSink(DataFlow::Node n) {
  exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
}

module ReverseDnsValueConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof ReverseDnsUserInput }

  predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

module ReverseDnsValueFlow = DataFlow::Global<ReverseDnsValueConfig>;

module ReverseDnsTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof ReverseDnsUserInput }

  predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

module ReverseDnsTaintFlow = TaintTracking::Global<ReverseDnsTaintConfig>;

module ReverseDnsFlowTest implements TestSig {
  string getARelevantTag() { result = ["hasReverseDnsValueFlow", "hasReverseDnsTaintFlow"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasReverseDnsValueFlow" and
    exists(DataFlow::Node sink | ReverseDnsValueFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasReverseDnsTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      ReverseDnsTaintFlow::flow(src, sink) and not ReverseDnsValueFlow::flow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<ReverseDnsFlowTest>
