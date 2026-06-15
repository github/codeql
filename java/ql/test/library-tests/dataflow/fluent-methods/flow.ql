import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSteps
import utils.test.InlineFlowTest
import DefaultFlowTest
import TaintFlow::PathGraph

class Model extends FluentMethod {
  Model() { this.getName() = "modelledFluentMethod" }
}

class IdentityModel extends ValuePreservingMethod {
  IdentityModel() { this.getName() = "modelledIdentity" }

  override predicate returnsValue(int arg) { arg = 0 }
}
