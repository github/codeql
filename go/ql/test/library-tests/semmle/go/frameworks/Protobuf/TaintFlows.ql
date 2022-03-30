import go

class UntrustedFunction extends Function {
  UntrustedFunction() { this.getName() = ["getUntrustedString", "getUntrustedBytes"] }
}

class UntrustedSource extends DataFlow::Node, UntrustedFlowSource::Range {
  UntrustedSource() { this = any(UntrustedFunction f).getACall() }
}

class SinkFunction extends Function {
  SinkFunction() { this.getName() = ["sinkString", "sinkBytes"] }
}

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "testconfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(SinkFunction f).getACall().getAnArgument()
  }
}

from TaintTracking::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source, sink
