import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

class LocalSource extends DataFlow::Node {
  LocalSource() {
    this instanceof UserInput and
    not this instanceof RemoteFlowSource
  }
}

predicate isTestSink(DataFlow::Node n) {
  exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
}

class LocalValueConf extends DataFlow::Configuration {
  LocalValueConf() { this = "LocalValueConf" }

  override predicate isSource(DataFlow::Node n) { n instanceof LocalSource }

  override predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

class LocalTaintConf extends TaintTracking::Configuration {
  LocalTaintConf() { this = "LocalTaintConf" }

  override predicate isSource(DataFlow::Node n) { n instanceof LocalSource }

  override predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

class LocalFlowTest extends InlineExpectationsTest {
  LocalFlowTest() { this = "LocalFlowTest" }

  override string getARelevantTag() { result = ["hasLocalValueFlow", "hasLocalTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasLocalValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | any(LocalValueConf c).hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasLocalTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      any(LocalTaintConf c).hasFlow(src, sink) and not any(LocalValueConf c).hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
