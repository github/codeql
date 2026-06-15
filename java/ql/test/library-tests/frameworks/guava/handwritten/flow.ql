import java
import semmle.code.java.dataflow.TaintTracking
import utils.test.InlineExpectationsTest

module TaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("taint") }

  predicate isSink(DataFlow::Node n) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

module TaintFlow = TaintTracking::Global<TaintFlowConfig>;

module ValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("taint") }

  predicate isSink(DataFlow::Node n) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

module ValueFlow = DataFlow::Global<ValueFlowConfig>;

module HasFlowTest implements TestSig {
  string getARelevantTag() { result = ["numTaintFlow", "numValueFlow"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "numTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, int num | TaintFlow::flow(src, sink) |
      not ValueFlow::flow(src, sink) and
      value = num.toString() and
      sink.getLocation() = location and
      element = sink.toString() and
      num = strictcount(DataFlow::Node src2 | TaintFlow::flow(src2, sink))
    )
    or
    tag = "numValueFlow" and
    exists(DataFlow::Node sink, int num | ValueFlow::flowTo(sink) |
      value = num.toString() and
      sink.getLocation() = location and
      element = sink.toString() and
      num = strictcount(DataFlow::Node src2 | ValueFlow::flow(src2, sink))
    )
  }
}

import MakeTest<HasFlowTest>
