import java
import TestUtilities.InlineFlowTest
import semmle.code.java.dataflow.FlowSources

class SliceValueFlowConf extends DefaultValueFlowConf {
  override predicate isSource(DataFlow::Node source) {
    super.isSource(source) or source instanceof RemoteFlowSource
  }
}

class SliceTaintFlowConf extends DefaultTaintFlowConf {
  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    super.allowImplicitRead(node, c)
    or
    isSink(node) and
    c.(DataFlow::SyntheticFieldContent).getField() = "androidx.slice.Slice.action"
  }
}
