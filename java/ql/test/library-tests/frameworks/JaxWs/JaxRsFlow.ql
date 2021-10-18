import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class TaintFlowConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node n) {
    super.isSource(n)
    or
    n instanceof RemoteFlowSource
  }
}

class ValueFlowConf extends DefaultValueFlowConf {
  override predicate isSource(DataFlow::Node n) {
    super.isSource(n)
    or
    n instanceof RemoteFlowSource
  }
}
