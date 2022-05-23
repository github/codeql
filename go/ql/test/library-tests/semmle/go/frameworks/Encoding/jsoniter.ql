import go
import semmle.go.security.CommandInjection

class UntrustedFunction extends Function {
  UntrustedFunction() { this.getName() = ["getUntrustedString", "getUntrustedBytes"] }
}

class UntrustedSource extends DataFlow::Node, UntrustedFlowSource::Range {
  UntrustedSource() { this = any(UntrustedFunction f).getACall() }
}

from CommandInjection::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
