import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class RemoteValueConf extends DefaultValueFlowConf {
  override predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }
}

class RemoteTaintConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }
}

class RemoteFlowTest extends InlineFlowTest {
  override string getARelevantTag() { result = ["hasRemoteValueFlow", "hasRemoteTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasRemoteValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | getValueFlowConfig().hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasRemoteTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      getTaintFlowConfig().hasFlow(src, sink) and not getValueFlowConfig().hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
