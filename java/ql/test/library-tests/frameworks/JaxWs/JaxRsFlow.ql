import java
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineFlowTest

class TaintFlowConf extends TaintTracking::Configuration {
  TaintFlowConf() { this = "qltest:frameworks:jax-rs-taint" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }

  override int fieldFlowBranchLimit() { result = 1000 }
}

class ValueFlowConf extends DataFlow::Configuration {
  ValueFlowConf() { this = "qltest:frameworks:jax-rs-value" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }

  // TODO: move to default?
  override int fieldFlowBranchLimit() { result = 1000 }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { result = any(ValueFlowConf config) }

  override DataFlow::Configuration getTaintFlowConfig() { result = any(TaintFlowConf config) }
}
