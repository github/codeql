import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:frameworks:rabbitmq" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | node.asExpr() = ma.getAnArgument())
  }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override DataFlow::Configuration getTaintFlowConfig() { result = any(Conf c) }
}
