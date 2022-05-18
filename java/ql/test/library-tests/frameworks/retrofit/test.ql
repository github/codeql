import java
import TestUtilities.InlineFlowTest

class FlowConf extends DefaultValueFlowConf {
  override predicate isSink(DataFlow::Node n) { super.isSink(n) or sinkNode(n, "open-url") }
}
