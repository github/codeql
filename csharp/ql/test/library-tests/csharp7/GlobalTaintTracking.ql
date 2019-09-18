import csharp

class DataflowConfiguration extends TaintTracking::Configuration {
  DataflowConfiguration() { this = "taint tracking configuration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(Expr).getValue() = "tainted"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(LocalVariable v | sink.asExpr() = v.getInitializer())
  }
}

from DataflowConfiguration config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select source, sink
