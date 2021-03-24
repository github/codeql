import java
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:frameworks:guava" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "numTaintFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "numTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf, int num | conf.hasFlow(src, sink) |
      value = num.toString() and
      sink.getLocation() = location and
      element = sink.toString() and
      num = strictcount(DataFlow::Node src2 | conf.hasFlow(src2, sink))
    )
  }
}
