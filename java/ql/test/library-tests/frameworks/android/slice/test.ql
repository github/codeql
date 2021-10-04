import java
import TestUtilities.InlineFlowTest
import semmle.code.java.dataflow.FlowSources

class SliceValueFlowConf extends DefaultValueFlowConf {
  override predicate isSource(DataFlow::Node source) {
    super.isSource(source) or source instanceof RemoteFlowSource
  }
}
