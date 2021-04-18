import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSteps
import TestUtilities.InlineExpectationsTest

class Conf extends DataFlow::Configuration {
  Conf() { this = "qltest:dataflow:fluent-methods" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("source")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

class Model extends FluentMethod {
  Model() { this.getName() = "modelledFluentMethod" }
}

class IdentityModel extends ValuePreservingMethod {
  IdentityModel() { this.getName() = "modelledIdentity" }

  override predicate returnsValue(int arg) { arg = 0 }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "hasTaintFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
