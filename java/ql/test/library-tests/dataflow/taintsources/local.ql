import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

class LocalSource extends DataFlow::Node {
  LocalSource() {
    this instanceof UserInput and
    not this instanceof RemoteFlowSource
  }
}

class LocalValueConf extends DefaultValueFlowConf {
  override predicate isSource(DataFlow::Node n) { n instanceof LocalSource }
}

class LocalTaintConf extends DefaultTaintFlowConf {
  override predicate isSource(DataFlow::Node n) { n instanceof LocalSource }
}

class LocalFlowTest extends InlineFlowTest {
  override string getARelevantTag() { result = ["hasLocalValueFlow", "hasLocalTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasLocalValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | getValueFlowConfig().hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasLocalTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      getTaintFlowConfig().hasFlow(src, sink) and not getValueFlowConfig().hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
