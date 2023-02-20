import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class Conf extends TaintTracking::Configuration {
  Conf() { this = "test:AndroidExternalFlowConf" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

class ExternalStorageTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override DataFlow::Configuration getTaintFlowConfig() { result instanceof Conf }
}
