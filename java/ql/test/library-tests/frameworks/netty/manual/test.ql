import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class Conf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node node) {
    super.isSource(node)
    or
    node instanceof RemoteFlowSource
  }
}

class LegacyConfig extends EnableLegacyConfiguration {
  LegacyConfig() { this instanceof Unit }
}
