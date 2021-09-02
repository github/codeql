import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineExpectationsTest

class DefaultValueFlowConf extends DataFlow::Configuration {
  DefaultValueFlowConf() { this = "qltest:defaultValueFlowConf" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("source")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

class DefaultTaintFlowConf extends TaintTracking::Configuration {
  DefaultTaintFlowConf() { this = "qltest:defaultTaintFlowConf" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("source")
  }

  override predicate isSink(DataFlow::Node n) {
    n.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

class InlineFlowTest extends InlineExpectationsTest {
  InlineFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | getValueFlowConfig().hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      getTaintFlowConfig().hasFlow(src, sink) and not getValueFlowConfig().hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }

  DataFlow::Configuration getValueFlowConfig() { result = any(DefaultValueFlowConf config) }

  DataFlow::Configuration getTaintFlowConfig() { result = any(DefaultTaintFlowConf config) }
}
