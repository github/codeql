import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class SourceTaintFlowConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }
}
