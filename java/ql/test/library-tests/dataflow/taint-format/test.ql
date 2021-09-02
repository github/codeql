import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineFlowTest

class TaintFlowConf extends TaintTracking::Configuration {
  TaintFlowConf() { this = "qltest:dataflow:format" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) { n instanceof DataFlow::ExprNode }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { result = any(TaintFlowConf config) }
}
