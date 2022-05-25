import go
import TestUtilities.InlineExpectationsTest

class SourceFunction extends Function {
  SourceFunction() { this.getName() = "source" }
}

class SinkFunction extends Function {
  SinkFunction() { this.getName() = "sink" }
}

class TestConfig extends DataFlow::Configuration {
  TestConfig() { this = "testconfig" }

  override predicate isSource(DataFlow::Node source) {
    source = any(SourceFunction f).getACall().getAResult()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(SinkFunction f).getACall().getAnArgument()
  }
}

class PromotedMethodsTest extends InlineExpectationsTest {
  PromotedMethodsTest() { this = "PromotedMethodsTest" }

  override string getARelevantTag() { result = "promotedmethods" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(TestConfig config, DataFlow::Node source, DataFlow::Node sink |
      config.hasFlow(source, sink)
    |
      sink.hasLocationInfo(file, line, _, _, _) and
      element = sink.toString() and
      value = source.getEnclosingCallable().getName() and
      tag = "promotedmethods"
    )
  }
}
