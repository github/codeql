import go
import ModelValidation
import utils.test.InlineExpectationsTest
import MakeTest<FlowTest>

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Method m |
      m.hasQualifiedName("github.com/nonexistent/test", "S1", "Source") and
      source = m.getACall().getResult()
    )
    or
    exists(Field f |
      f.hasQualifiedName("github.com/nonexistent/test", "S1", "SourceField") and
      source = f.getARead()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Method m |
      m.hasQualifiedName("github.com/nonexistent/test", "S1", "Sink") and
      sink = m.getACall().getArgument(0)
    )
    or
    exists(Field f |
      f.hasQualifiedName("github.com/nonexistent/test", "S1", "SinkField") and
      any(DataFlow::Write w).writesField(_, f, sink)
    )
  }
}

module Flow = TaintTracking::Global<Config>;

module FlowTest implements TestSig {
  string getARelevantTag() { result = "ql_S1" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "ql_S1" and
    exists(DataFlow::Node sink | Flow::flowTo(sink) |
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString() and
      value = ""
    )
  }
}

class MyStep extends DataFlow::FunctionModel, Method {
  MyStep() { this.hasQualifiedName("github.com/nonexistent/test", "S1", "Step") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and output.isResult()
  }
}
