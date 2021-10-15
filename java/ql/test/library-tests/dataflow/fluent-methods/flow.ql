import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSteps
import TestUtilities.InlineFlowTest

class Model extends FluentMethod {
  Model() { this.getName() = "modelledFluentMethod" }
}

class IdentityModel extends ValuePreservingMethod {
  IdentityModel() { this.getName() = "modelledIdentity" }

  override predicate returnsValue(int arg) { arg = 0 }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }
}
