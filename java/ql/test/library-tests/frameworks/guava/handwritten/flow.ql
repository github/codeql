import java
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest

class TaintFlowConf extends TaintTracking::Configuration {
  TaintFlowConf() { this = "qltest:frameworks:guava-taint" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

class ValueFlowConf extends DataFlow::Configuration {
  ValueFlowConf() { this = "qltest:frameworks:guava-value" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }

  override int fieldFlowBranchLimit() { result = 100 }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["numTaintFlow", "numValueFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "numTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, TaintFlowConf tconf, int num |
      tconf.hasFlow(src, sink)
    |
      not any(ValueFlowConf vconf).hasFlow(src, sink) and
      value = num.toString() and
      sink.getLocation() = location and
      element = sink.toString() and
      num = strictcount(DataFlow::Node src2 | tconf.hasFlow(src2, sink))
    )
    or
    tag = "numValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, ValueFlowConf vconf, int num |
      vconf.hasFlow(src, sink)
    |
      value = num.toString() and
      sink.getLocation() = location and
      element = sink.toString() and
      num = strictcount(DataFlow::Node src2 | vconf.hasFlow(src2, sink))
    )
  }
}
