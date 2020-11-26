import go

class SourceFunction extends Function {
  SourceFunction() { this.getName() = ["getTaintedByteArray", "getTaintedPatch"] }
}

class SinkFunction extends Function {
  SinkFunction() { this.getName() = ["sinkByteArray", "sinkPatch"] }
}

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "testconfig" }

  override predicate isSource(DataFlow::Node source) {
    source = any(SourceFunction f).getACall().getAResult()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(SinkFunction f).getACall().getAnArgument()
  }
}

from TestConfig config, DataFlow::PathNode source, DataFlow::PathNode sink, int i
where config.hasFlowPath(source, sink) and source.hasLocationInfo(_, i, _, _, _)
select source, sink, i order by i
