import go
import TestUtilities.InlineExpectationsTest

class SourceFunction extends Function {
  SourceFunction() { this.getName() = "source" }
}

class SinkFunction extends Function {
  SinkFunction() { this.getName() = "sink" }
}

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "testconfig" }

  override predicate isSource(DataFlow::Node source) {
    source = any(SourceFunction f).getACall().getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(SinkFunction f).getACall().getArgument(0)
  }
}

class K8sIoApiCoreV1Test extends InlineExpectationsTest {
  K8sIoApiCoreV1Test() { this = "K8sIoApiCoreV1Test" }

  override string getARelevantTag() { result = "KsIoApiCoreV" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(TestConfig config, DataFlow::PathNode source, DataFlow::PathNode sink |
      config.hasFlowPath(source, sink) and
      sink.hasLocationInfo(file, line, _, _, _) and
      element = sink.toString() and
      value = "" and
      tag = "KsIoApiCoreV"
    )
  }
}
