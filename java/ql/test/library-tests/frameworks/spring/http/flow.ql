import java
import semmle.code.java.frameworks.spring.Spring
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest

class TaintFlowConf extends TaintTracking::Configuration {
  TaintFlowConf() { this = "qltest:frameworks:spring-taint-flow" }

  override predicate isSource(DataFlow::Node n) {
    exists(string name | name.matches("taint%") |
      n.asExpr().(MethodAccess).getMethod().hasName(name)
    )
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

class ValueFlowConf extends DataFlow::Configuration {
  ValueFlowConf() { this = "qltest:frameworks:spring-value-flow" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasTaintFlow", "hasValueFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, TaintFlowConf conf | conf.hasFlow(src, sink) |
      not any(ValueFlowConf vconf).hasFlow(src, sink) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, ValueFlowConf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
