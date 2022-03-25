import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class SourceValueFlowConf extends DefaultValueFlowConf {
  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }
}

class SourceInlineFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { none() }
}
