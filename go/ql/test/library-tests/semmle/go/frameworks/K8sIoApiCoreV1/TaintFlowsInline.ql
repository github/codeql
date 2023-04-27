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

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TestConfig config, DataFlow::PathNode sink |
      config.hasFlowPath(_, sink) and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString() and
      value = "" and
      tag = "KsIoApiCoreV"
    )
  }
}
