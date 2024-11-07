import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import TestUtilities.InlineExpectationsTest
import MakeTest<FlowTest>

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(FileSystemAccess fsa).getAPathArgument() }
}

module Flow = TaintTracking::Global<Config>;

module FlowTest implements TestSig {
  string getARelevantTag() { result = "ql_I1" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "ql_I1" and
    exists(DataFlow::Node sink | Flow::flowTo(sink) |
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString() and
      value = ""
    )
  }
}

class MySource extends RemoteFlowSource::Range instanceof DataFlow::Node {
  MySource() {
    exists(Method m |
      m.hasQualifiedName("github.com/nonexistent/test", "I1", "Source") and
      this = m.getACall().getResult()
    )
  }
}

class MyStep extends DataFlow::FunctionModel, Method {
  MyStep() { this.hasQualifiedName("github.com/nonexistent/test", "I1", "Step") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and output.isResult()
  }
}

class MySink extends FileSystemAccess::Range, DataFlow::CallNode {
  MySink() {
    exists(Method m |
      m.hasQualifiedName("github.com/nonexistent/test", "I1", "Sink") and
      this = m.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
}
