import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.security.CommandInjection
import CommandInjection::Flow::PathGraph

class UntrustedFunction extends Function {
  UntrustedFunction() { this.getName() = ["getUntrustedString", "getUntrustedBytes"] }
}

class RemoteSource extends DataFlow::Node, RemoteFlowSource::Range {
  RemoteSource() { this = any(UntrustedFunction f).getACall() }
}

from CommandInjection::Flow::PathNode source, CommandInjection::Flow::PathNode sink
where CommandInjection::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
