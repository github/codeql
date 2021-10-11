import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

predicate isTestSink(DataFlow::Node n) {
  exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
}

class RemoteValueConf extends DataFlow::Configuration {
  RemoteValueConf() { this = "RemoteValueConf" }

  override predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

class RemoteTaintConf extends TaintTracking::Configuration {
  RemoteTaintConf() { this = "RemoteTaintConf" }

  override predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

class RemoteFlowTest extends InlineExpectationsTest {
  RemoteFlowTest() { this = "RemoteFlowTest" }

  override string getARelevantTag() { result = ["hasRemoteValueFlow", "hasRemoteTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasRemoteValueFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink | any(RemoteValueConf c).hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasRemoteTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      any(RemoteTaintConf c).hasFlow(src, sink) and not any(RemoteValueConf c).hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
