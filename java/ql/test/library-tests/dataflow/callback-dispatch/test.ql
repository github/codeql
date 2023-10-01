import java
import semmle.code.java.dataflow.DataFlow
import TestUtilities.InlineExpectationsTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodAccess).getMethod().hasName("source") }

  predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

module Flow = DataFlow::Global<Config>;

module HasFlowTest implements TestSig {
  string getARelevantTag() { result = "flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    exists(DataFlow::Node src, DataFlow::Node sink | Flow::flow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = src.asExpr().(MethodAccess).getAnArgument().toString()
    )
  }
}

import MakeTest<HasFlowTest>
