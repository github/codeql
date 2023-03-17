import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class ValueFlowConf extends DataFlow::Configuration {
  ValueFlowConf() { this = "ValueFlowConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

class Test extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { result = any(ValueFlowConf config) }
}
