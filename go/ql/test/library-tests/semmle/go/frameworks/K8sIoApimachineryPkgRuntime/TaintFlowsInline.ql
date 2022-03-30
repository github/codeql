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
    source = any(SourceFunction f).getACall().getAResult()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(SinkFunction f).getACall().getAnArgument()
  }
}

class K8sIoApimachineryPkgRuntimeTest extends InlineExpectationsTest {
  K8sIoApimachineryPkgRuntimeTest() { this = "KsIoApimachineryPkgRuntimeTest" }

  override string getARelevantTag() { result = "KsIoApimachineryPkgRuntime" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(TestConfig config, DataFlow::PathNode source, DataFlow::PathNode sink |
      config.hasFlowPath(source, sink) and
      sink.hasLocationInfo(file, line, _, _, _) and
      element = sink.toString() and
      value = "" and
      tag = "KsIoApimachineryPkgRuntime"
    )
  }
}
