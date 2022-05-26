import go
import TestUtilities.InlineExpectationsTest

class Sink extends DataFlow::Node {
  Sink() {
    exists(DataFlow::CallNode c | c.getTarget().getName() = "sink" | this = c.getAnArgument())
  }
}

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "testconfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
}

class MissingDataFlowTest extends InlineExpectationsTest {
  MissingDataFlowTest() { this = "MissingDataFlow" }

  override string getARelevantTag() { result = "noflow" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "noflow" and
    value = "" and
    exists(Sink sink |
      not any(TestConfig c).hasFlow(_, sink) and
      sink.hasLocationInfo(file, line, _, _, _) and
      element = sink.toString()
    )
  }
}

class HttpResponseBodyTest extends InlineExpectationsTest {
  HttpResponseBodyTest() { this = "HttpResponseBodyTest" }

  override string getARelevantTag() { result = "responsebody" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "responsebody" and
    exists(HTTP::ResponseBody rb |
      rb.hasLocationInfo(file, line, _, _, _) and
      element = rb.toString() and
      value = "'" + rb.toString() + "'"
    )
  }
}
