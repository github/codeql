import go

class SinkFunction extends Function {
  SinkFunction() { this.getName() = ["useFiles", "useJSON", "usePerson", "useString"] }
}

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "testconfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(SinkFunction f).getACall().getAnArgument()
  }
}

from TaintTracking::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink, int i
where config.hasFlowPath(source, sink) and source.hasLocationInfo(_, i, _, _, _)
select source, sink, i order by i
