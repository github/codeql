import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

predicate isTestSink(DataFlow::Node n) {
  exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
}

module RemoteValueConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

module RemoteValueFlow = DataFlow::Global<RemoteValueConfig>;

module RemoteTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

module RemoteTaintFlow = TaintTracking::Global<RemoteTaintConfig>;

class RemoteFlowTest extends InlineExpectationsTest {
  RemoteFlowTest() { this = "RemoteFlowTest" }

  override string getARelevantTag() { result = ["hasRemoteValueFlow", "hasRemoteTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasRemoteValueFlow" and
    exists(DataFlow::Node sink | RemoteValueFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasRemoteTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      RemoteTaintFlow::flow(src, sink) and not RemoteValueFlow::flow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
