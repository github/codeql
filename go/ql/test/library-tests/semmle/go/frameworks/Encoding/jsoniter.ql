import go
import semmle.go.security.CommandInjection
import CommandInjection::Flow::PathGraph

class UntrustedFunction extends Function {
  UntrustedFunction() { this.getName() = ["getUntrustedString", "getUntrustedBytes"] }
}

class UntrustedSource extends DataFlow::Node, UntrustedFlowSource::Range {
  UntrustedSource() { this = any(UntrustedFunction f).getACall() }
}

from CommandInjection::Flow::PathNode source, CommandInjection::Flow::PathNode sink
where CommandInjection::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
