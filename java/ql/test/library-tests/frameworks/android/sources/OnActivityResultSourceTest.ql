import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class SourceValueFlowConf extends DefaultValueFlowConf {
  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }
}

class SourceInlineFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { none() }
}
