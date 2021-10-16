import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class ProviderTaintFlowConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }
}

class ProviderInlineFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }
}
