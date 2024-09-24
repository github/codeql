import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

class MySource extends RemoteFlowSource::Range instanceof DataFlow::Node {
  MySource() {
    exists(Method m |
      m.hasQualifiedName("github.com/nonexistent/test", "S1", "Source") and
      this = m.getACall().getResult()
    )
  }
}

class MyStep extends DataFlow::FunctionModel, Method {
  MyStep() { this.hasQualifiedName("github.com/nonexistent/test", "S1", "Step") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input.isParameter(0) and output.isResult()
  }
}

class MySink extends FileSystemAccess::Range, DataFlow::CallNode {
  MySink() {
    exists(Method m |
      m.hasQualifiedName("github.com/nonexistent/test", "S1", "Sink") and
      this = m.getACall()
    )
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(FileSystemAccess fsa).getAPathArgument() }
}

module Flow = DataFlow::Global<Config>;

query predicate paths(DataFlow::Node source, DataFlow::Node sink) { Flow::flow(source, sink) }
