import javascript

class TaintConfig extends TaintTracking::Configuration {
  TaintConfig() { this = "test taint config" }

  override predicate isSource(DataFlow::Node node) {
    node = DataFlow::moduleImport("externalTaintSource").getACall()
  }

  override predicate isSink(DataFlow::Node node) {
    node = DataFlow::moduleImport("externalTaintSink").getACall().getArgument(0)
  }
}

from TaintConfig cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source, sink
